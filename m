From: Michael Christie <michaelc@cs.wisc.edu>
Subject: Re: CmdSN greather than MaxCmdSN protocol error in LIO Iser
Date: Tue, 12 Nov 2013 13:46:12 -0600
Message-ID: <4D51E650-1B70-4F95-B57A-32B71E65DD9E@cs.wisc.edu>
References: <697D97E420EE024FB7451B574CD4991BCA064554@NTXBOIMBX05.micron.com> <1384204653.12281.7.camel@haakon3.risingtidesystems.com> <1384216960.12281.24.camel@haakon3.risingtidesystems.com> <1384217317.12281.26.camel@haakon3.risingtidesystems.com> <1384219874.12281.42.camel@haakon3.risingtidesystems.com> <B9FFC16A-0592-498D-A7C3-7ABB3EFA61FD@cs.wisc.edu> <541331AC-770C-4AB8-ACB0-4964F76F9F1E@cs.wisc.edu> <1384230893.12281.72.camel@haakon3.risingtidesystems.com> <52824B3C.10203@cs.wisc.edu> <697D97E420EE024FB7451B574CD4991BCA064F17@NTXBOIMBX05.micron.com>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:42213 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755623Ab3KLTqa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Nov 2013 14:46:30 -0500
In-Reply-To: <697D97E420EE024FB7451B574CD4991BCA064F17@NTXBOIMBX05.micron.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moussa Ba (moussaba)" <moussaba@micron.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, Nicholas Bellinger <nab@daterainc.com>, Or Gerlitz <ogerlitz@mellanox.com>, linux-scsi <linux-scsi@vger.kernel.org>


On Nov 12, 2013, at 12:18 PM, Moussa Ba (moussaba) <moussaba@micron.com> wrote:
> 
> I am attaching error codes on the inititator that seem to coincide with the timeout errors.
> 
> [  261.855254]  connection6:0: pdu (op 0x65 itt 0x1) rejected. Reason code 0x4
> [  261.855266]  connection6:0: pdu (op 0xa itt 0x1) rejected. Reason code 0x4
> [  261.855268]  connection6:0: pdu (op 0x51 itt 0x1) rejected. Reason code 0x4
> 


The initiator does not handle rejects. This is actually the 2nd time I have
seen one in 10 years. It logs them just lets the command timeout.