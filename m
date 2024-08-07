Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1AA83207
	for <linux-scsi@vger.kernel.org>; Wed,  7 Aug 2024 02:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722996372; cv=none; b=FXxndpVDDnK9abfu4/UZ4vk5VJNr3AZUsw9+Q0el+568Euv/osHnHLWD90VK9azUqZ/IeMIpGwd14Aoc9YDhXdkz9lsB9LbCtKj0qy99gcoGfvODnj1JM+JRUtrxSXwsLw87evSrcvkWoGA2nYqVcMFpr/zT5RcizHHCFizisMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722996372; c=relaxed/simple;
	bh=n4dw5O/1WKMpuhJZo5ttH7VlTFXxdEe1t+ea61MSy18=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=H8pCobDVj++VRaYpbPNKgZgLZPYAGkv0JrytrW5fqCQmJG5GEgwW3pZIVbCs3nNiuRpP5QVdOxKlf4x/RGy48pxUz9y1Et00gGCtWSZH0xbT9rDHvmKsuSPJQ1mW/q+HCxW2N+KAhcXkjEKn2L/Bv1jxqb0oMrknt1VlUV79F9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dx0DvrGU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dx0DvrGU"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7E811C4AF0F
	for <linux-scsi@vger.kernel.org>; Wed,  7 Aug 2024 02:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722996371;
	bh=n4dw5O/1WKMpuhJZo5ttH7VlTFXxdEe1t+ea61MSy18=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=dx0DvrGUGtE3pa5ZubzoDtszI6y7Upmfxq3nyFsjvfbIFth/SURwtYDz0N6FMXbIH
	 WE6zAdw3HgllghxSlyAGUwsPbJWH85WR7W8o/NFiwXU88hYObXxa9XPOBnaEGmB4+7
	 r/w+i71NgbqowPhfV38DswtXTYLPYdWm5ek2mRjggbtzVhEVSWzn9Ehu7n74ktfRDU
	 ur2xWE+z9tL19rxTFflYaHfE2gW4Np2F0RTVQN0UC4Ska724rwefKLwL4eVxrEEgcI
	 RUukKWBewP4v0/uPnKj5NYDfeasW21OfUiZD9nKErQ8jPMkffM7wRO12Xl01uDTn7G
	 JylzpgEuQ5NcQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 75546C53BBF; Wed,  7 Aug 2024 02:06:11 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 219128] lpfc driver reports failed messages
Date: Wed, 07 Aug 2024 02:06:11 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: lixc17@lenovo.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-219128-11613-DH1LqZMpJ8@https.bugzilla.kernel.org/>
In-Reply-To: <bug-219128-11613@https.bugzilla.kernel.org/>
References: <bug-219128-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

https://bugzilla.kernel.org/show_bug.cgi?id=3D219128

--- Comment #4 from Xavier (lixc17@lenovo.com) ---
Hi, Justin
Thanks for your quick reply.
I found I don't have permission to change the bug assignee even I am the
reporter.

Regards,
--Xavier

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
