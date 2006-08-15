From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] update some devinfo entries
Date: Tue, 15 Aug 2006 17:44:09 -0400
Message-ID: <44E24029.7040405@cs.wisc.edu>
References: <1155675629.16063.9.camel@max>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:16835 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1750775AbWHOWnu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Aug 2006 18:43:50 -0400
In-Reply-To: <1155675629.16063.9.camel@max>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

Mike Christie wrote:
> The RHEL4 kernel contains some devinfo entries that
> upstream does not so I thought I should try and update
> upstream.
> 
> Most of them are new entries or pretty straight forward,
> except this one:
> 
> -       {"HITACHI", "OPEN-E", "*", BLIST_ATTACH_PQ3 | BLIST_SPARSELUN | BLIST_LARGELUN},
> +       {"HITACHI", "OPEN-", "*", BLIST_ATTACH_PQ3 | BLIST_SPARSELUN | BLIST_LARGELUN},
> 
> In RHEL we used to have OPEN-V, OPEN-L and OPEN-V and those used
> BLIST_SPARSELUN | BLIST_LARGELUN. We consolidated those to just
> OPEN-.
> 
> Upstream has "OPEN-E" with
> BLIST_ATTACH_PQ3 | BLIST_SPARSELUN | BLIST_LARGELUN
> 
> So I am not sure if consolidating that one into OPEN- is ok
> since I am not adding BLIST_ATTACH_PQ3 for all OPEN-.
> 

Ooops, I meant that I am now adding BLIST_ATTACH_PQ3 for all devices
matching OPEN-.
