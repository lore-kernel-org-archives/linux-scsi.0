From: Jes Sorensen <jes@wildopensource.com>
Subject: Re: STK9840/SYM53c875 ODD transfer in DATA OUT phase
Date: 26 Sep 2003 08:38:23 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <m3k77vhghs.fsf@trained-monkey.org>
References: <20030926102021.GA32502@chihiro.cern.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from trained-monkey.org ([209.217.122.11]:2314 "EHLO
	trained-monkey.org") by vger.kernel.org with ESMTP id S261675AbTIZMi1
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Sep 2003 08:38:27 -0400
In-Reply-To: <20030926102021.GA32502@chihiro.cern.ch>
List-Id: linux-scsi@vger.kernel.org
To: KELEMEN Peter <Peter.Kelemen@cern.ch>
Cc: linux-scsi@vger.kernel.org

>>>>> "Peter" == KELEMEN Peter <Peter.Kelemen@cern.ch> writes:

Peter> [ Please Cc: me as I'm not subscribed to the list.  Thanks. ]
Peter> Hello,

Peter> Since 2.4.18, we have a problem with the above combo if and
Peter> only if the transfer is odd number of bytes.  Even byte
Peter> transfer works well.  The error message we see is:

Peter,

Have you tried using a different SCSI controller to see if it is
driver related? Any chance you could try 2.4.21?

Cheers,
Jes
