From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: Dynamic scsi_debug module
Date: Fri, 07 Feb 2014 15:08:01 -0800
Message-ID: <1391814481.1155.64.camel@haakon3.risingtidesystems.com>
References: <52F5339B.7070503@ubuntu.com>
	 <yq1r47eslb2.fsf@sermon.lab.mkp.net> <52F551CF.30406@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:43392 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbaBGXFR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Feb 2014 18:05:17 -0500
In-Reply-To: <52F551CF.30406@ubuntu.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Phillip Susi <psusi@ubuntu.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Fri, 2014-02-07 at 16:36 -0500, Phillip Susi wrote:
> On 2/7/2014 3:46 PM, Martin K. Petersen wrote:
> > The question is how much sense it makes to invest in scsi_debug now
> > that we have the LIO target in the kernel?
> 
> Thanks, I hadn't heard of this.  It looks interesting, though a bit
> complicated.
> 

Just FYI, a 'apt-get install targetcli' should set you up with
everything on the user-space side required to run LIO target +
associated fabric drivers.

--nab

