From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [SCSI] mpt2sas T10 DIF fixes
Date: Wed, 22 Aug 2012 14:36:35 -0400
Message-ID: <yq1lih6bwp8.fsf@sermon.lab.mkp.net>
References: <1329788184-6477-1-git-send-email-martin.petersen@oracle.com>
	<50237151.9000801@suse.com> <yq1lihdh5jc.fsf@sermon.lab.mkp.net>
	<20120819144932.GT19851@reaktio.net>
	<yq1ehn2ewpq.fsf@sermon.lab.mkp.net>
	<20120819153004.GU19851@reaktio.net>
	<yq1628eet0s.fsf@sermon.lab.mkp.net>
	<20120820104818.GW19851@reaktio.net>
	<yq1k3wtcc22.fsf@sermon.lab.mkp.net>
	<112A412BB11A1242B37129D931BCE534352E7BA8@FMSMSX103.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:34790 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933259Ab2HVSg6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Aug 2012 14:36:58 -0400
In-Reply-To: <112A412BB11A1242B37129D931BCE534352E7BA8@FMSMSX103.amr.corp.intel.com>
	(Dave Jiang's message of "Tue, 21 Aug 2012 15:50:38 +0000")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Jiang, Dave" <dave.jiang@intel.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Pasi =?utf-8?B?S8Okcmtrw6RpbmVu?= <pasik@iki.fi>, Ankit Jain <jankit@suse.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James.Bottomley@hansenpartnership.com" <James.Bottomley@hansenpartnership.com>, "Eric.Moore@lsi.com" <Eric.Moore@lsi.com>

>>>>> "dj" == Jiang, Dave <dave.jiang@intel.com> writes:

>> Yes. The only thing that doesn't work is RAID5/6.

dj> Just curious, has any work been done on this? Wondering what the
dj> roadblocks are to get this support in....

Nobody has done the work, that's all. And it's not entirely trivial. The
8 bytes of metadata for a parity sector is not "valid" T10 protection
information, for instance.

-- 
Martin K. Petersen	Oracle Linux Engineering
