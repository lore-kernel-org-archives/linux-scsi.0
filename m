From: David C Somayajulu <david.somayajulu@qlogic.com>
Subject: Re: [PATCH 3/3] qla4xxx: iospace_config move defn
Date: Wed, 09 Aug 2006 12:23:04 -0700
Message-ID: <1155151384.3850.3.camel@dcslnxpc.site>
References: <20060809182406.2021.90492.stgit@bebe.enoyolf.org>
	 <20060809184243.2021.48891.stgit@bebe.enoyolf.org>
	 <44DA21BE.3050506@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:41816 "EHLO avexch1.qlogic.com")
	by vger.kernel.org with ESMTP id S1751326AbWHITXE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Aug 2006 15:23:04 -0400
In-Reply-To: <44DA21BE.3050506@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Doug Maxey <dwm@enoyolf.org>, Ravi Anand <ravi.anand@qlogic.com>, open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org

On Wed, 2006-08-09 at 13:56 -0400, Mike Christie wrote:
> Doug Maxey wrote:
> > From: Doug Maxey <dwm@enoyolf.org>
> > 
> > Move the defn before the caller, and remove the decl.
> > 
> 
> I think not doing the defn before the caller is nice, but I honestly
> could care less either way as far as merging things goes (it seems like
> Christoph hates then but people like Jeff let the driver writer do what
> they want). Qlogic seems to love doing it, so are they ok with all these
> patches?
We have no problem with these patches since it makes the code cleaner
and makes everyone happy.
-david S.
