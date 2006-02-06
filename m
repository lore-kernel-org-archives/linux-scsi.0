From: Olaf Hering <olh@suse.de>
Subject: Re: 2.6.16-rc1 crash in scsi_target_reap_work
Date: Mon, 6 Feb 2006 23:26:22 +0100
Message-ID: <20060206222622.GA13062@suse.de>
References: <20060117000533.GA27473@suse.de> <43CE8C26.4000202@us.ibm.com> <20060119210514.GA7118@suse.de> <20060130104613.GA26551@suse.de> <20060130164954.GA4711@suse.de> <20060206220434.GA11732@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns2.suse.de ([195.135.220.15]:41168 "EHLO mx2.suse.de")
	by vger.kernel.org with ESMTP id S932391AbWBFW0X (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Feb 2006 17:26:23 -0500
Received: from Relay1.suse.de (mail2.suse.de [195.135.221.8])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx2.suse.de (Postfix) with ESMTP id A55EB1CC39
	for <linux-scsi@vger.kernel.org>; Mon,  6 Feb 2006 23:26:22 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20060206220434.GA11732@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

 On Mon, Feb 06, Olaf Hering wrote:

> I started with:
>  git-bisect bad 7a0268fa1a3613f2c526a9b3058701b277f6abe1
>  git-bisect good a020ff412f0ecbb1e4aae1681b287e5785dd77b5

I just learned there is a log:

.git/BISECT_LOG
git-bisect start
# bad: [7a0268fa1a3613f2c526a9b3058701b277f6abe1] powerpc/64: per cpu data optimisations
git-bisect bad 7a0268fa1a3613f2c526a9b3058701b277f6abe1
# good: [a020ff412f0ecbb1e4aae1681b287e5785dd77b5] Fix pragma packing in ip2 driver
git-bisect good a020ff412f0ecbb1e4aae1681b287e5785dd77b5
# bad: [864472e9b8fa76ffaad17dfcb84d79e16df6828c] NFSv4: Make open recovery track O_RDWR, O_RDONLY and O_WRONLY correctly
git-bisect bad 864472e9b8fa76ffaad17dfcb84d79e16df6828c
# bad: [25c862cc9ea9b312c25a9f577f91b973131f1261] Merge git://git.kernel.org/pub/scm/linux/kernel/git/sam/kbuild
git-bisect bad 25c862cc9ea9b312c25a9f577f91b973131f1261
# good: [f61ea1b0c825a20a1826bb43a226387091934586] Merge git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6
git-bisect good f61ea1b0c825a20a1826bb43a226387091934586
# good: [f2e46561cc1afa82b18b2fc6efc8510ec57c7d7d] sky2: no irq disable needed during tx
git-bisect good f2e46561cc1afa82b18b2fc6efc8510ec57c7d7d
# good: [d779188d2baf436e67fe8816fca2ef53d246900f] Merge branch 'upstream-linus' of master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/netdev-2.6
git-bisect good d779188d2baf436e67fe8816fca2ef53d246900f
# good: [1cb9e8e01d2c73184e2074f37cd155b3c4fdaae6] Merge branch 'upstream' of master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev
git-bisect good 1cb9e8e01d2c73184e2074f37cd155b3c4fdaae6
# good: [54e08a2392e99ba9e48ce1060e0b52a39118419c] kbuild: tags file generation fixup
git-bisect good 54e08a2392e99ba9e48ce1060e0b52a39118419c
# bad: [52347f4e810ba323d02cd2c26b5d738f4a2c3d5e] Merge git://git.kernel.org/pub/scm/linux/kernel/git/bunk/trivial
git-bisect bad 52347f4e810ba323d02cd2c26b5d738f4a2c3d5e
# bad: [f62870db3c73683fe566a05efa2a05f3faeb44f5] Documentation/SubmittingPatches: update Trivial Patch Monkey information
git-bisect bad f62870db3c73683fe566a05efa2a05f3faeb44f5
# good: [4a4efbdee278b2f4ed91aad2db5c006ff754276e] s/retreiv/retriev/g
git-bisect good 4a4efbdee278b2f4ed91aad2db5c006ff754276e

Guess I need to let the good ones run much longer now.


-- 
short story of a lazy sysadmin:
 alias appserv=wotan
