From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] 2.4.21 fix race condition in sg.c
Date: Fri, 27 Jun 2003 11:00:03 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030627150002.GA22378@gtf.org>
References: <1056723054.1825.16.camel@mulgrave> <002a01c33cbc$5e45d960$e0019d89@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host-64-213-145-173.atlantasolutions.com ([64.213.145.173]:37097
	"EHLO havoc.gtf.org") by vger.kernel.org with ESMTP id S264437AbTF0Ops
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Jun 2003 10:45:48 -0400
Content-Disposition: inline
In-Reply-To: <002a01c33cbc$5e45d960$e0019d89@cybernetics.com>
List-Id: linux-scsi@vger.kernel.org
To: Tony Battersby <tonyb@cybernetics.com>
Cc: 'James Bottomley' <James.Bottomley@SteelEye.com>, 'Alan Cox' <alan@lxorguk.ukuu.org.uk>, 'SCSI Mailing List' <linux-scsi@vger.kernel.org>, marcelo@conectiva.com.br, dougg@torque.net

Personally, I advocate the KISS approach:

if it's an SMP race where you find yourself thinking about memory
barriers, you should probably just go ahead and use a spinlock :)

	Jeff



