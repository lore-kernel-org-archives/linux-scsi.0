From: Andrew Vasquez <praka@san.rr.com>
Subject: Re: Qlogic qla2xxx driver up for testing
Date: Mon, 19 May 2003 16:44:43 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030519234443.GA17588@praka.local.home>
References: <1053378680.1850.24.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from orngca-mls01.socal.rr.com ([66.75.160.16]:60069 "EHLO
	orngca-mls01.socal.rr.com") by vger.kernel.org with ESMTP
	id S261262AbTESXgh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 May 2003 19:36:37 -0400
Received: from san.rr.com (66-75-128-22.san.rr.com [66.75.128.22])
	by orngca-mls01.socal.rr.com (8.11.4/8.11.3) with ESMTP id h4JNl0V04079
	for <linux-scsi@vger.kernel.org>; Mon, 19 May 2003 16:47:00 -0700 (PDT)
Received: from san.rr.com (localhost [127.0.0.1])
	by san.rr.com (8.12.3/8.12.3/SuSE Linux 0.6) with ESMTP id h4JNiijW017614
	for <linux-scsi@vger.kernel.org>; Mon, 19 May 2003 16:44:44 -0700
Received: (from praka@localhost)
	by san.rr.com (8.12.3/8.12.3/Submit) id h4JNihFn017613
	for linux-scsi@vger.kernel.org; Mon, 19 May 2003 16:44:43 -0700
Content-Disposition: inline
In-Reply-To: <1053378680.1850.24.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

James,

> I've taken the Qlogic 8.00.00.b1 driver and put it up under 
> bitkeeper at
> 
> http://linux-scsi.bkbits.net/scsi-qla2xxx-2.5
> 
> I've moved the text files into Documentation/scsi, but other than that
> made no alterations to the qlogic driver.
> 
> It will build for the qla2300, but the builds fail for qla2100 and
> qla2200 giving me no way to test it.
>

I've just uploaded a new version of the driver to the SF site that
fixes the 21xx/22xx build problems:

	http://marc.theaimsgroup.com/?l=linux-scsi&m=105338567812190&w=2
 
> The qla2xxx/Makefile is rather convoluted, and makes it look like
> building more than one type of driver non-modular may be a problem.
>

I'm not entirely thrilled with the build process.  Trying to shoehorn
kbuild into builing three driver binaries was a real mess.  Also, you
are correct, building more than one driver in a non-modular fashion
currently fails -- redefinitions of symbols... (modular builds of the
drivers work fine).

I've read the documentation in kbuild/makefiles.txt, but
unfortuantely, given the form and structure of the driver sources,
I've yet to fashion a simpler build method for the drivers,  any
suggestions?

Regards,
Andrew Vasquez
