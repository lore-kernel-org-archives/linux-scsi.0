From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: scsi_scan.c question
Date: Wed, 16 Oct 2002 14:57:28 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021016145728.A6657@eng2.beaverton.ibm.com>
References: <20021016213518.GE8159@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from northrelay03.pok.ibm.com (northrelay03.pok.ibm.com [9.56.224.151])
	by e2.ny.us.ibm.com (8.12.2/8.12.2) with ESMTP id g9GLvU0K033590
	for <linux-scsi@vger.kernel.org>; Wed, 16 Oct 2002 17:57:30 -0400
Received: from gateway1.beaverton.ibm.com (gateway1.beaverton.ibm.com [138.95.180.2])
	by northrelay03.pok.ibm.com (8.12.3/NCO/VER6.4) with ESMTP id g9GLvRYF087148
	for <linux-scsi@vger.kernel.org>; Wed, 16 Oct 2002 17:57:28 -0400
Received: from eng2.beaverton.ibm.com (eng2.beaverton.ibm.com [9.47.57.17])
	by gateway1.beaverton.ibm.com (8.11.6/8.11.6) with ESMTP id g9GLsx815600
	for <linux-scsi@vger.kernel.org>; Wed, 16 Oct 2002 14:54:59 -0700
Received: (from patman@localhost)
	by eng2.beaverton.ibm.com (8.10.0.Beta10/8.8.5/token.aware-1.2) id g9GLvSp06925
	for linux-scsi@vger.kernel.org; Wed, 16 Oct 2002 14:57:28 -0700 (PDT)
In-Reply-To: <20021016213518.GE8159@redhat.com>; from dledford@redhat.com on Wed, Oct 16, 2002 at 05:35:18PM -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Wed, Oct 16, 2002 at 05:35:18PM -0400, Doug Ledford wrote:
> Is anyone still working on this code or have the changes other people 
> wanted to make all been integrated?

Not that I know of.

I never re-sent patches to change the GFP_ATOMIC to GFP_KERNEL. With
the sleep debugging, and per other discussions, no in_interrupt check
should be needed. I can create, test, and send them to you or
the list, but the change is simple.

More device attributes should be added, so we can move away from
/proc/scsi - like vendor, product, online, and maybe more.

The device model "name" should be replaced for now with our own
"uid" field, and name used as a generic description, probably the
same thing that is put into the type field right now, or something
for disk like "scsi direct-access" and for tape "scsi sequential-access".

-- Patrick Mansfield
