Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BA9980043;
	Tue, 24 Sep 2024 20:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727211247; cv=none; b=EczEzoHF/k8TyzHzkzBg48juX9fVvWSm8vYBIJhtXvTXGBdlaLS8xMU+k2TlFcAEmQ7uXvfN7ftJ97u4O2udRxNWQOHJE8CoafzWeSY4+2L/9q5x0CCEWYvP4TcoSMZ1WocnBDtaf0xsVOrRDnBXTBtPk1URRyZPQaLHim1nYD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727211247; c=relaxed/simple;
	bh=chVW3wuAaN+gkR1FFSlfUEezqENx4IL2HisGopvf4Ro=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=CDjte8xZBaPO48/16EB6OG6iNYQOJjNuBgNo/4QHLE596Ff+GTYOnFrTQzQmZ74QR28JtL3kZvoJwE/TfSx2UPb6snvyr1UHWo3jiVduV+Yd5mY4RWF24sR1lbeSG2F+MltNcmBQ6g8u5qCNuf0WYlFT2UK8OukGDCozIb71Qt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eEh3s0OX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eEh3s0OX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98C1CC4CEC4;
	Tue, 24 Sep 2024 20:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727211246;
	bh=chVW3wuAaN+gkR1FFSlfUEezqENx4IL2HisGopvf4Ro=;
	h=Date:From:To:Cc:Subject:From;
	b=eEh3s0OXWIig0/MNkyjQw2jlKZIADeyldAL9kqOFrpClTJC6NdNz7iGLtqEwI0Jq0
	 px1zSYyu7nwDmrjEUPAm3Gl/PFLRGJbWGHpZrHy6dfUmjIQ5NExJ91H619NDjyx8aR
	 IxXP8lb+h1GCXHV1KKOKp5shWlc2tkWRc+W1Qa3E=
Date: Tue, 24 Sep 2024 16:54:04 -0400
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, helpdesk@kernel.org
Subject: Bouncing maintainer: Michael Reed (QLOGIC QLA1280 SCSI DRIVER)
Message-ID: <20240924-shapeless-oarfish-of-improvement-34aef3@lemur>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hello:

I'm reaching out to the list associated with this subsystem:

  - QLOGIC QLA1280 SCSI DRIVER

The email address for the only maintainer listed for that subsystem is
bouncing:

  M: Michael Reed <mdr@sgi.com>

There are several possible courses of action:

1. If anyone knows the new email address for the maintainer, please ask them
   to submit a patch for MAINTAINERS and .mailmap files.

2. If this maintainer stepped away from their duties, please submit a patch to
   MAINTAINERS to update the M: entry with the new maintainer for this
   subsystem.

3. If there is no new maintainer for this subsystem, it will be marked as
   Orphaned.

The goal is to have no bouncing M: entries in the maintainers file, so please
follow up as soon as you have decided on the correct course of action.

Best regards,
--
Konstantin Ryabitsev
Linux Foundation

bugspray track
