From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH RFC 0/9] [SCSI] Enhanced sense and Unit Attention handling
Date: Mon, 28 Jan 2013 10:18:22 -0600
Message-ID: <5106A4CE.7030400@cs.wisc.edu>
References: <1358526434-1173-1-git-send-email-emilne@redhat.com> <CAO+b5-oKyPoSdKJPcyaf4FkDUNH25Cwwz=_C4WiwvpfauNqStQ@mail.gmail.com> <51011D2E.305@suse.de> <CAO+b5-ptjPEbCrKEpdCEZBCh5Xs7ycXQA5V+iohAL4TSfbUzFg@mail.gmail.com> <5106939E.1010301@tributary.com> <51069CC8.3000103@acm.org> <51069ED3.5010204@tributary.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:45851 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752841Ab3A1QSd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Jan 2013 11:18:33 -0500
In-Reply-To: <51069ED3.5010204@tributary.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Linton <jlinton@tributary.com>
Cc: Bart Van Assche <bvanassche@acm.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 01/28/2013 09:52 AM, Jeremy Linton wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> On 1/28/2013 9:44 AM, Bart Van Assche wrote:
>> when using Fibre Channel as transport layer. I'm looking for a solution 
>> that also works with other SCSI transports, e.g. iSCSI and SRP.
> 
> 	Doesn't iSCSI have a SNS server you can subscribe to that provides similar
> functionality (name services and port add/remove)? SAS has the BROADCAST
> functionality too which can act as an AEN.
> 

iSCSI does have a SNS server. In iSCSI it is called iSNS. The problem is
that it is not widely used.
