From: "Tony Battersby" <tonyb@cybernetics.com>
Subject: RE: [PATCH] kill of ->command
Date: Mon, 9 Jun 2003 15:19:43 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <000701c32ebc$15c8b3f0$e0019d89@cybernetics.com>
References: <20030609114515.D5618@one-eyed-alien.net>
Reply-To: <tonyb@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host02.cybernetics.com ([206.246.200.18]:13834 "EHLO
	cybernetics.com") by vger.kernel.org with ESMTP id S264385AbTFITGP
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 Jun 2003 15:06:15 -0400
In-Reply-To: <20030609114515.D5618@one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org
To: 'Matthew Dharm' <mdharm-scsi@one-eyed-alien.net>
Cc: linux-scsi@vger.kernel.org

> BTW, is NULL == (void*)0 everywhere?  I seem to recall places where it
> isn't....

>From the recesses of my memory, NULL is always equivalent to (void*)0, but
that doesn't necessarily mean that a NULL pointer has a bit pattern of all
zeros as stored in the computer's memory.  NULL is replaced with (void*)0 by
the preprocessor, and then the compiler for the target architecture
determines the appropriate bit pattern for (void*)0.  You can think of
(void*)0 as just a name for the null pointer which doesn't determine its
actual value.  On some old architectures, memset to zero does not
automatically set pointers to NULL.  I do not remember the specific
architectures which are affected, but I doubt Linux runs or will ever run on
any of them.

For modern code, it is safe to assume that memset to zero will set pointers
to NULL.

Anthony J. Battersby
Cybernetics

