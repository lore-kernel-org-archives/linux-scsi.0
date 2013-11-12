From: "Moussa Ba (moussaba)" <moussaba@micron.com>
Subject: RE: CmdSN greather than MaxCmdSN protocol error in LIO Iser
Date: Tue, 12 Nov 2013 19:48:13 +0000
Message-ID: <697D97E420EE024FB7451B574CD4991BCA064FDB@NTXBOIMBX05.micron.com>
References: <697D97E420EE024FB7451B574CD4991BCA064554@NTXBOIMBX05.micron.com>
 <1384204653.12281.7.camel@haakon3.risingtidesystems.com>
 <1384216960.12281.24.camel@haakon3.risingtidesystems.com>
 <1384217317.12281.26.camel@haakon3.risingtidesystems.com>
 <1384219874.12281.42.camel@haakon3.risingtidesystems.com>
 <B9FFC16A-0592-498D-A7C3-7ABB3EFA61FD@cs.wisc.edu>
 <541331AC-770C-4AB8-ACB0-4964F76F9F1E@cs.wisc.edu>
 <1384230893.12281.72.camel@haakon3.risingtidesystems.com>
 <52824B3C.10203@cs.wisc.edu>
 <697D97E420EE024FB7451B574CD4991BCA064F17@NTXBOIMBX05.micron.com>
 <4D51E650-1B70-4F95-B57A-32B71E65DD9E@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout.micron.com ([137.201.242.129]:55671 "EHLO
	mailout.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756845Ab3KLTtG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Nov 2013 14:49:06 -0500
In-Reply-To: <4D51E650-1B70-4F95-B57A-32B71E65DD9E@cs.wisc.edu>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Christie <michaelc@cs.wisc.edu>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, Nicholas Bellinger <nab@daterainc.com>, Or Gerlitz <ogerlitz@mellanox.com>, linux-scsi <linux-scsi@vger.kernel.org>

> -----Original Message-----
> From: Michael Christie [mailto:michaelc@cs.wisc.edu]
> Sent: Tuesday, November 12, 2013 11:46 AM
> To: Moussa Ba (moussaba)
> Cc: Nicholas A. Bellinger; target-devel@vger.kernel.org; Nicholas
> Bellinger; Or Gerlitz; linux-scsi
> Subject: Re: CmdSN greather than MaxCmdSN protocol error in LIO Iser
> 
> 
> On Nov 12, 2013, at 12:18 PM, Moussa Ba (moussaba)
> <moussaba@micron.com> wrote:
> >
> > I am attaching error codes on the inititator that seem to coincide
> with the timeout errors.
> >
> > [  261.855254]  connection6:0: pdu (op 0x65 itt 0x1) rejected. Reason
> code 0x4
> > [  261.855266]  connection6:0: pdu (op 0xa itt 0x1) rejected. Reason
> code 0x4
> > [  261.855268]  connection6:0: pdu (op 0x51 itt 0x1) rejected. Reason
> code 0x4
> >
> 
> 
> The initiator does not handle rejects. This is actually the 2nd time I
> have
> seen one in 10 years. It logs them just lets the command timeout.

Well, I saw 8 already this morning :-). Looking at the reason code it is a protocol error, which is obviously related to the CmdSN/MaxCmdSN mismatch.

Moussa
