From: Ramya Desai <ramya.desai@gmail.com>
Subject: Asynchronous Mass storage driver
Date: Wed, 24 Jun 2009 21:40:15 +0530
Message-ID: <3e7aae30906240910p18cc23e9v10e5cf5b7b6cd91a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.24]:12365 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631AbZFXQKN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Jun 2009 12:10:13 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: USB list <linux-usb@vger.kernel.org>, linux-scsi@vger.kernel.org

Dear Experts,

I am trying to develop an asynchronous mass storage driver for my custom device.
I am using the default mass storage driver as my basis.

My first question, is the completion routine the first one to be
called if the request finishes?

I wanted to my command submit to USB stack (submitURB()) code in the
driver context and look for the another command from the upper layer.
To do so I wanted to move the rest of the code to completion routine.
If I return USB_STOR_TRANSPORT_GOOD in completion routine, where this
return is going to?

Is there any Asynchronous mass storage reference code available?

Thanks and regards,
RD
