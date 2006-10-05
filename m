From: ravianand <ravi.anand@qlogic.com>
Subject: Re: Symbol conflict in QLA drivers
Date: Thu, 5 Oct 2006 07:27:10 -0700
Message-ID: <20061005142710.GA8141@ranandlinuxbox.qlogic.org>
References: <29174.1160055701@warthog.cambridge.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:33824 "EHLO avexch1.qlogic.com")
	by vger.kernel.org with ESMTP id S1751238AbWJEO1T (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Oct 2006 10:27:19 -0400
Content-Disposition: inline
In-Reply-To: <29174.1160055701@warthog.cambridge.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: linux-driver@qlogic.com, linux-scsi@vger.kernel.org

>On Thu, 05 Oct 2006, David Howells wrote:
> 
> Two different QLA drivers (qla2xxx and qla4xxx) both define a variable called:
> 
> 	extended_error_logging
> 
> This results in a namespace conflict when both drivers are compiled in (make
> allyesconfig for example).
> 
We will push a patch to fix it in qla4xxx driver.

Thanx
Ravi
