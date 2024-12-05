Received: from mail115-100.sinamail.sina.com.cn (mail115-100.sinamail.sina.com.cn [218.30.115.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 572C51D9A7E
	for <linux-scsi@vger.kernel.org>; Thu,  5 Dec 2024 12:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=218.30.115.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733402108; cv=none; b=sK3qMdclicoUmldTlgSVdyK6Cg1hSu64VevGEP+bUp6+IbMyAkY/kVWVrUfUzekeLhk3MQDnoPyB0mDM+/yY1RsO4WkyJHYCaWLa3S/uRnKY5NdhHX5JAKOeeuQw8tyF7A5vEmHvQ5fqEtgRgHKU4TwLVomVOqfgqgh4Ozo2mlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733402108; c=relaxed/simple;
	bh=nANvtx7c3NYEL+jwGTQwUyolvRCb6Hqum4ekjHDe6m4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MR2Bbi+xAzQiYzTi20UIB+6GkJfNGMijvlYRNAb8FXIsZ8+eN3rkjwepe47OmOtTnRKkU9Kk6wOPwZICZtmppXHszYdd/YIA0TKkKP8dsgSfKkerje9orxBh77aMaUOggYEeekyp42m4VwlrCGhONmH5J8CeXWCfXt735HQzcOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sina.com; spf=pass smtp.mailfrom=sina.com; arc=none smtp.client-ip=218.30.115.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sina.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sina.com
X-SMAIL-HELO: localhost.localdomain
Received: from unknown (HELO localhost.localdomain)([113.118.66.103])
	by sina.com (10.185.250.23) with ESMTP
	id 67519D590000558B; Thu, 5 Dec 2024 20:32:35 +0800 (CST)
X-Sender: hdanton@sina.com
X-Auth-ID: hdanton@sina.com
Authentication-Results: sina.com;
	 spf=none smtp.mailfrom=hdanton@sina.com;
	 dkim=none header.i=none;
	 dmarc=none action=none header.from=hdanton@sina.com
X-SMAIL-MID: 9925078913343
X-SMAIL-UIID: 1A8F74A1370D476FB586BAB940D2592A-20241205-203235-1
From: Hillf Danton <hdanton@sina.com>
To: syzbot <syzbot+ac962f01776f0d739973@syzkaller.appspotmail.com>
Cc: linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [scsi?] possible deadlock in balance_pgdat (2)
Date: Thu,  5 Dec 2024 20:32:16 +0800
Message-Id: <20241205123216.2354-1-hdanton@sina.com>
In-Reply-To: <6750ff61.050a0220.17bd51.0080.GAE@google.com>
References: 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 04 Dec 2024 17:18:25 -0800
> syzbot found the following issue on:
> 
> HEAD commit:    d8b78066f4c9 Merge tag 'tty-6.13-rc1' of git://git.kernel...
> git tree:       upstream
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=125380df980000

#syz test: https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git for-6.14/block
