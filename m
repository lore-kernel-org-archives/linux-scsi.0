From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: unique entry points for all driver hosts
Date: Mon, 12 May 2003 16:38:21 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030512233821.GF3226@beaverton.ibm.com>
References: <0E3FA95632D6D047BA649F95DAB60E570185F192@EXA-ATLANTA.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.129]:7418 "EHLO e31.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S262941AbTELXXK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 May 2003 19:23:10 -0400
Content-Disposition: inline
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E570185F192@EXA-ATLANTA.se.lsil.com>
List-Id: linux-scsi@vger.kernel.org
To: "Mukker, Atul" <atulm@lsil.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Mukker, Atul [atulm@lsil.com] wrote:
> Why doesn't mid-layer allow LLDs to specify separate entry points to various
> hosts attached to the same driver. Like some other entries in the Scsi Host
> Template, entry points should also  allowed to be overridden.
> 
> 
> Thanks

Is there a issue you are hitting of common host template functions and
selecting unique host instance functions using hostdata?

-andmike
--
Michael Anderson
andmike@us.ibm.com

