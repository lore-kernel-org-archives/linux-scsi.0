From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH RFC 0/9] [SCSI] Enhanced sense and Unit Attention
 handling
Date: Mon, 28 Jan 2013 11:04:45 -0500
Message-ID: <1359389085.4420.443.camel@localhost.localdomain>
References: <1358526434-1173-1-git-send-email-emilne@redhat.com>
	 <CAO+b5-oKyPoSdKJPcyaf4FkDUNH25Cwwz=_C4WiwvpfauNqStQ@mail.gmail.com>
	 <51011D2E.305@suse.de>
	 <CAO+b5-ptjPEbCrKEpdCEZBCh5Xs7ycXQA5V+iohAL4TSfbUzFg@mail.gmail.com>
	 <5106939E.1010301@tributary.com> <51069CC8.3000103@acm.org>
	 <51069ED3.5010204@tributary.com>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53490 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753221Ab3A1QEs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Jan 2013 11:04:48 -0500
In-Reply-To: <51069ED3.5010204@tributary.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Linton <jlinton@tributary.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Mon, 2013-01-28 at 09:52 -0600, Jeremy Linton wrote:
> On 1/28/2013 9:44 AM, Bart Van Assche wrote:
> > when using Fibre Channel as transport layer. I'm looking for a solution 
> > that also works with other SCSI transports, e.g. iSCSI and SRP.
> 
> 	Doesn't iSCSI have a SNS server you can subscribe to that provides similar
> functionality (name services and port add/remove)? SAS has the BROADCAST
> functionality too which can act as an AEN.
> 

I don't think you have to have an iSNS server to use iSCSI, though.
It is possible to use Send Targets for discovery.  At least that used
to be the case.

-Ewan


