From: Lincoln Dale <ltd@cisco.com>
Subject: Re: [BUG] modprobe qla2300 doesn't complete
Date: Fri, 12 Mar 2004 23:30:28 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <5.1.0.14.2.20040312232611.044c2e98@mira-sjcm-3.cisco.com>
References: <20040310221241.GA7903@colo.lackof.org>
 <20040305041850.GA9124@colo.lackof.org>
 <20040305071721.GA9684@praka.local.home>
 <20040305172147.GB17305@colo.lackof.org>
 <20040309164033.GA21648@praka.local.home>
 <20040310221241.GA7903@colo.lackof.org> <20040312061119.GA6402@praka.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-1-in.cisco.com ([171.71.176.70]:2322 "EHLO
	sj-iport-1.cisco.com") by vger.kernel.org with ESMTP
	id S262095AbUCLNaj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Mar 2004 08:30:39 -0500
In-Reply-To: <20040312061119.GA6402@praka.local.home>
References: <20040310221241.GA7903@colo.lackof.org>
 <20040305041850.GA9124@colo.lackof.org>
 <20040305071721.GA9684@praka.local.home>
 <20040305172147.GB17305@colo.lackof.org>
 <20040309164033.GA21648@praka.local.home>
 <20040310221241.GA7903@colo.lackof.org>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Grant Grundler <grundler@parisc-linux.org>, linux-scsi@vger.kernel.org

At 05:11 PM 12/03/2004, Andrew Vasquez wrote:
>So, I'm not entirely clear on what else is going on with your
>configuration.  I'll try to get some runtime on an ia64 machine
>tomorrow to perform the same test.

if you have access to some SAN test equipment (e.g. Agilent SAN Tester), or 
SAN-rootkit (e.g. we have internal tools which can cause RSCN floods, FLOGI 
floods, PLOGI floods, rogue injection of vast quantities of NS 
registrations ...), it currently doesn't seem too hard to upset the qla2300 
into a never-ending incomplete state such that Grant has seen.

have you guys ever considered rate-limiting NS queries following receiving 
RSCNs?


cheers,

lincoln.

