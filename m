From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 0/3 ver2] iscsi bidi & varlen support
Date: Mon, 18 Feb 2008 17:08:37 +0200
Message-ID: <47B99F75.6030400@panasas.com>
References: <47A20E85.6040906@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:10405 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753089AbYBRPJP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Feb 2008 10:09:15 -0500
In-Reply-To: <47A20E85.6040906@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>, Pete Wyckoff <pw@osc.edu>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, open-iscsi@googlegroups.com, Benny Halevy <bhalevy@panasas.com>, Daniel.E.Messinger@seagate.com

On Thu, Jan 31 2008 at 20:08 +0200, Boaz Harrosh <bharrosh@panasas.com> wrote:
> Cheers after 1.3 years these can go in.
> 
> [PATCH 1/3] iscsi: extended cdb support
>    The varlen support is not yet in mainline for
>   block and scsi-ml. But the API for drivers will
>   not change. All LLD need to do is max_command to
>   the it's maximum and be ready for bigger commands.
>   This is what's done here. Once these commands start
>   coming iscsi will be ready for them.
> 
> [PATCH 2/3] iscsi: bidi support - libiscsi
> [PATCH 3/3] iscsi: bidi support - iscsi_tcp
>   bidirectional commands support in iscsi.
>   iSER is not yet ready, but it will not break.
>   There is already a mechanism in libiscsi that will
>   return error if bidi commands are sent iSER way.
> 
> Pete please send me the iSER bits so we can port them
> to this latest version.
> 
> Mike these patches are ontop of iscs branch of the iscsi
> git tree, they will apply but for compilation you will need
> to sync with Linus mainline. The patches are for the in-tree
> iscsi code. I own you the compat patch for the out-off-tree
> code, but this I will only be Sunday.
> 
> If we do it fast it might get accepted to 2.6.25 merge window
> 
> Everybody is invited to a party at Shila ben-yhuda 52 Tel-Aviv
> 9:45 pm. Drinks and wonderful see-food on us :)
> 
> Boaz
>  
> -
Everything the same as before. But working this time. Also
Pete's comment about second patch, was correct and code is now
fixed.

I have got Mike's Signed-off-by, on these they were tested and
approved by him. So they are for scsi-misc. But ... James? is
there any chance these can go into scsi-rc-fixes for the 2.6.25
kernel? The reason they are so late was mainly because of a fallout
in the merge process and a bug that was introduced because of that,
but they were intended to go together with bidi into 2.6.25. Also
as an important client code to the bidi-api that is introduced in
2.6.25 kernel.

Thanks
Boaz
