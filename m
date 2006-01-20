From: Andrew Morton <akpm@osdl.org>
Subject: Re: [Bugme-new] [Bug 5776] New: initio: Kernel crash while
 launching K3B app. with SCSI driver
Date: Fri, 20 Jan 2006 00:12:16 -0800
Message-ID: <20060120001216.385a60ac.akpm@osdl.org>
References: <200512230432.jBN4WCku009586@fire-2.osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:54435 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1750720AbWATIMs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Jan 2006 03:12:48 -0500
In-Reply-To: <200512230432.jBN4WCku009586@fire-2.osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "bugme-daemon@kernel-bugs.osdl.org" <bugme-daemon@bugzilla.kernel.org>

bugme-daemon@bugzilla.kernel.org wrote:
>
> ttp://bugzilla.kernel.org/show_bug.cgi?id=5776
> 
>             Summary: initio: Kernel crash while launching K3B app. with SCSI
>                      driver
>      Kernel Version: 2.6.14

The initio driver keeled over during some sort of scanning/querying operation.
