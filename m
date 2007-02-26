From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: end to end error recovery musings
Date: Mon, 26 Feb 2007 10:59:50 -0800
Message-ID: <45E32E26.1050000@zytor.com>
References: <45DEF6EF.3020509@emc.com> <45DF80C9.5080606@zytor.com> <20070224003723.GS10715@schatzie.adilger.int> <20070224023229.GB4380@thunk.org> <17890.28977.989203.938339@notabene.brown> <20070226132511.GB8154@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from terminus.zytor.com ([192.83.249.54]:49608 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932435AbXBZTAc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Feb 2007 14:00:32 -0500
In-Reply-To: <20070226132511.GB8154@thunk.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>, Neil Brown <neilb@suse.de>, "H. Peter Anvin" <hpa@zytor.com>, Ric Wheeler <ric@emc.com>, Linux-ide <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-raid@vger.kernel.org, Tejun Heo <htejun@gmail.com>, James Bottomley <James.Bottomley@SteelEye.com>, Mark Lord <mlord@pobox.com>, Jens Axboe <jens.axboe@oracle.com>, "Clark, Nathan" <Clark_Nathan@emc.com>, "Singh, Arvinder" <Singh_Arvinder@emc.com>, "De Smet, Jochen" <DeSmet_Jochen@emc.com>, "Farmer, Matt" <Farmer_Matt@emc.com>, linux-fsdevel@vger.kernel.org, "Mizar, Sunita" <Mizar_Sunita@emc.com>

Theodore Tso wrote:
> 
> In any case, the reason why I bring this up is that it would be really
> nice if there was a way with a single laptop drive to be able to do
> snapshots and background fsck's without having to use initrd's with
> device mapper.
> 

This is a major part of why I've been trying to push integrated klibc to 
have all that stuff as a unified "kernel" deliverable.  Unfortunately, 
as you know, Linus apparently rejected the concept "at least for now" at 
LKS last year.

With klibc this stuff could still be in one single wrapper without funny 
dependencies, but wouldn't have to be ported to kernel space.

	-hpa
