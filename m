From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] 0/7 per scsi_device queue lock patches
Date: 27 Mar 2003 10:14:27 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1048781668.1789.54.camel@mulgrave>
References: <20030324175337.A14957@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20030324175337.A14957@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2003-03-24 at 19:53, Patrick Mansfield wrote:
> The following patches against recent 2.5.x bk (pulled on march 24, should
> apply fine on top of 2.5.66) leads to splitting the scsi queue_lock into a
> pre-scsi_device lock rather than the current per-scsi_host lock.

I've put all of these patches in a BK tree at

http://linux-scsi.bkbits.net/scsi-locking-2.5

for people to play with.

James


