From: Xiangliang Yu <yuxiangl@marvell.com>
Subject: RE: [PATCH 2/2] mvsas: add support for Task collector mode and
 fixed relative bugs
Date: Thu, 26 May 2011 01:16:26 -0700
Message-ID: <F766E4F80769BD478052FB6533FA745D19FAD846B5@SC-VEXCH4.marvell.com>
References: <mvsas-support-task-collector-mode>
	<1303825011-6345-1-git-send-email-yxlraid@gmail.com>
 <BANLkTi=xZnK6--p0gp+MAH1aRRJsPw9=Lg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <BANLkTi=xZnK6--p0gp+MAH1aRRJsPw9=Lg@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "dan.j.williams@gmail.com" <dan.j.williams@gmail.com>
Cc: "James.Bottomley@suse.de" <James.Bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Jacky Feng <jfeng@marvell.com>, Xiangliang Yu <yuxiangl@marvell.com>
List-Id: linux-scsi@vger.kernel.org

>> From: Xiangliang Yu <yuxiangl@marvell.com>
>>
>> 3.Unlock ap->lock within .lldd_execute_task for direct mode to improve performance

>Can you share more details about the performance impact?  Seems like
>this should be made generic across all libsas drivers... see below.

The direct mode should be change to task collector mode. Sorry, this is my fault.
We can use interrupt tasklet by unlocking ap->lock within .lldd_execute_task,
but interrupt tasklet has some issue, and I'm debugging it.
