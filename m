From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [patch] Re: SCSI logging sucks
Date: Wed, 07 Feb 2007 19:20:42 -0500
Message-ID: <yq17iut7b51.fsf@sermon.lab.mkp.net>
References: <45CA0716.5060803@redhat.com>
	<20070207153530.70412bc3.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:57068 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422828AbXBHAWK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Feb 2007 19:22:10 -0500
In-Reply-To: <20070207153530.70412bc3.randy.dunlap@oracle.com> (Randy Dunlap's message of "Wed, 7 Feb 2007 15:35:30 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Chuck Ebbert <cebbert@redhat.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, jejb <james.bottomley@steeleye.com>

>>>>> "Randy" == Randy Dunlap <randy.dunlap@oracle.com> writes:

Randy> There are a number of things that can be used for 'token' (you
Randy> can find them in the source: <file:drivers/scsi/scsi.c>), and
Randy> this allows you to select the types of information you want,
Randy> and the level allows you to select the level of verbosity.  """

There's a very convenient script called scsi_logging_level included in
(of all things) the s390-tools package.

Maybe provide a pointer to it -- or even just include it.  It's not
very big...

http://www-128.ibm.com/developerworks/linux/linux390/s390-tools-1.5.4.html

-- 
Martin K. Petersen	Oracle Linux Engineering

