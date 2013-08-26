From: "Reddy, Sreekanth" <Sreekanth.Reddy@lsi.com>
Subject: RE: [PATCH 0/2] mpt{2,3}sas remove disconnected phys on topology
 change
Date: Mon, 26 Aug 2013 15:52:21 +0530
Message-ID: <DCD177647606E9419ED923E0C8C4AA723006D9A536@inbmail02.lsi.com>
References: <1375351291-27107-1-git-send-email-jvesely@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1375351291-27107-1-git-send-email-jvesely@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Jan Vesely <jvesely@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "James E.J. Bottomley (JBottomley@parallels.com)" <JBottomley@parallels.com>
Cc: "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>, Tomas Henzl <thenzl@redhat.com>
List-Id: linux-scsi@vger.kernel.org

Hi James,

This patch set seem to be fine. Please consider this patch set.

Regards,
Sreekanth

>-----Original Message-----
>From: Jan Vesely [mailto:jvesely@redhat.com]
>Sent: Thursday, August 01, 2013 3:31 PM
>To: linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org
>Cc: Jan Vesely; Nandigama, Nagalakshmi; Reddy, Sreekanth; Tomas Henzl
>Subject: [PATCH 0/2] mpt{2,3}sas remove disconnected phys on topology
>change
>
>From: Jan Vesely <jvesely@redhat.com>
>
>These two patches add phy removal on link loss. This change keeps sysfs up-
>to-date with actually connected phys. Without these patches,  disconnected
>phys remain listed under their former ports.
>
>tested on both mpt2sas and mpt3sas hw.
>
>CC: Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>
>CC: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
>CC: Tomas Henzl <thenzl@redhat.com>
>Signed-off-by: Jan Vesely <jvesely@redhat.com>
>
>Jan Vesely (2):
>  mpt2sas: Remove phys on topology change.
>  mpt3sas: Remove phys on topology change
>
> drivers/scsi/mpt2sas/mpt2sas_transport.c |    5 ++++-
> drivers/scsi/mpt3sas/mpt3sas_transport.c |    5 ++++-
> 2 files changed, 8 insertions(+), 2 deletions(-)
>
