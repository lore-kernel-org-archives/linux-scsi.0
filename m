From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/2] scsi: Do not attach VPD to devices that don't support it
Date: Mon, 01 Feb 2016 20:22:41 -0500
Message-ID: <yq1wpqnoqhq.fsf@sermon.lab.mkp.net>
References: <20160121063039.3803.66.stgit@localhost.localdomain>
	<20160121063522.3803.23150.stgit@localhost.localdomain>
	<56A08AA7.6090709@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <56A08AA7.6090709@suse.de> (Hannes Reinecke's message of "Thu, 21
	Jan 2016 08:37:11 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Alexander Duyck <aduyck@mirantis.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, alexander.duyck@gmail.com, martin.petersen@oracle.com, linux-kernel@vger.kernel.org, shane.seymour@hpe.com, jthumshirn@suse.de
List-Id: linux-scsi@vger.kernel.org

>>>>> "Hannes" == Hannes Reinecke <hare@suse.de> writes:

Hannes> And in anycase, I guess we should be using the same logic sd.c
Hannes> is using. Please see the attached patch.

I'm OK with this change but please send it as a proper patch submission
so somebody else can review it.

-- 
Martin K. Petersen	Oracle Linux Engineering
