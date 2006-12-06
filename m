From: Etienne.Vogt@obspm.fr
Subject: Re: Infinite retries reading the partition table
Date: Wed, 6 Dec 2006 11:48:27 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0612061144340.11674@siolinb.obspm.fr>
References: <20061130214716.6306a586.akpm@osdl.org> <117439.97789.qm@web31803.mail.mud.yahoo.com>
 <20061130232916.6cbd1408.akpm@osdl.org>
Reply-To: Etienne.Vogt@obspm.fr
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from siolinb.obspm.fr ([145.238.2.18]:49093 "EHLO siolinb.obspm.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760466AbWLFKs2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 6 Dec 2006 05:48:28 -0500
In-Reply-To: <20061130232916.6cbd1408.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>



On Thu, 30 Nov 2006, Andrew Morton wrote:

> That looks like it prevents the IO error.  But why was an IO error causing
> an infinite loop?   What piece of code was initiating the retries?

Maybe it's related to the infinite domain validation retry loop problem
I reported on linux-scsi a few weeks ago ?

-- 
 		Etienne Vogt (Etienne.vogt@obspm.fr)
 		Observatoire de Paris-Meudon, France
