Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2FEC3A3E68;
	Wed, 14 Oct 2026 02:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791946727; cv=none; b=QuppUyCluG4ewl2fXOfhXosLMH3wJqR1fPZtLxqxNe5a1JTUgAZrMIW9N3IqmoXxe1VbHPBZLWD0tSkBlVHDKqKL7BKO6l1cc8DUJ8hBUlCg3l/BVNY6TaqHUQlL+KRTZgO+DroANW3w4wSTUBnypVV4UKNwBgGwv0ivlG9yTC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791946727; c=relaxed/simple;
	bh=XeVaH0LP/66TX08KN31/pVIP1uN4/LsfR/oWmm0peZg=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 MIME-Version:Content-Type; b=Lim7VsKoEyY4nkbskmZpVsfzd3dDt59JV+2VQwIYeqzP/7nP9usblJGaoTWvJ+RM8R5UGdxPM6co5x7CY2tMMpjquVskPsT2DiAfsnuTFXH1TeEYmJKUxnaitf2o2O3OwQl9kx5zC4EQrqPewx+jRoLhUEEECUVSgDpT1Z0hL3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XNQ6oewd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XNQ6oewd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22FA61F00893;
	Wed, 14 Oct 2026 02:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791946726;
	bh=XTtLNT+qMi8OpRJ5veOqJwf99KVXgomjNTfSzMA5QJw=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=XNQ6oewd3C9A2/vr3WriaYCj4yNgWj57FXj/vjuD8RM5pkeaCVIVJBJfLoMDhPhT7
	 7gx9e74igV6Q8P0FDE7qxbnTEgW39CKF0d7Gu28vsVM/To50tu9N3j9RqbiLjGcXU2
	 jTI5OMxdepb+UL5d0gM7W8lqDlTzK042YSIj2am3tMiSg3FyK8BnY1kZkpWoW44nQy
	 jql4Rz998oQYS8wlnptGzF6nd9nrgyHcMkOrPUvgRZ+1F8+wcSUggF/BBAuC8HpIYd
	 A5EihAfSYqRVJOilTTVebqN7aXIIK1oRFm/5oofDyL9n+tixS5rECxF1ZMwp120SM7
	 IIbD7WyYM3/+A==
To: Stanley Jhu <stanleyjhu@google.com>
Cc: "Martin K. Petersen" <mkp@kernel.org>,  "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,  Jonathan Corbet
 <corbet@lwn.net>,  Bart Van Assche <bvanassche@acm.org>,  Alim Akhtar
 <alim.akhtar@samsung.com>,  Shuah Khan <skhan@linuxfoundation.org>,  Randy
 Dunlap <rdunlap@infradead.org>,  Jeuk Kim <jeuk20.kim@samsung.com>,  Bean
 Huo <beanhuo@iokpp.de>,  linux-scsi@vger.kernel.org,
  linux-doc@vger.kernel.org,  linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] scsi: ufs: docs: Describe how to test with QEMU
From: "Martin K. Petersen" <mkp@kernel.org>
In-Reply-To: <20261012120059.1371653-1-stanleyjhu@google.com>
Message-ID: <yq1jynlf0o2.fsf@mail.kernel.org>
References: <20261012120059.1371653-1-stanleyjhu@google.com>
Date: Tue, 13 Oct 2026 22:58:44 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain


Stanley,

> QEMU emulates a UFS host controller and logical units, but the kernel
> tree does not mention it, so developers without UFS hardware have no
> documented way to exercise the UFS core.

Applied to 7.4/scsi-staging, thanks!

-- 
Martin K. Petersen
