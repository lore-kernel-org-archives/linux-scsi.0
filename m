From: Oliver Neukum <oliver@neukum.org>
Subject: Re: [PATCH v2 10/24] uas: zap_pending: data urbs should have
 completed at this time
Date: Thu, 02 Oct 2014 10:56:25 +0200
Message-ID: <1412240185.32060.12.camel@linux-0dmf.site>
References: <1410604011-3828-1-git-send-email-hdegoede@redhat.com>
	 <1410604011-3828-11-git-send-email-hdegoede@redhat.com>
	 <54149BA6.3010305@cogentembedded.com> <54155F49.8060904@redhat.com>
	 <1410690587.2270.2.camel@jarvis> <54156EDA.6050106@redhat.com>
	 <1410690872.2270.6.camel@jarvis>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out002.kontent.com ([81.88.40.216]:54316 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbaJBJKE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Oct 2014 05:10:04 -0400
In-Reply-To: <1410690872.2270.6.camel@jarvis>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Hans de Goede <hdegoede@redhat.com>, Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

On Sun, 2014-09-14 at 11:34 +0100, James Bottomley wrote:

> I'm agnostic on that.  I was just combatting the impression that you had
> to be careful about side effects in known macro statements.

No you haven't. But it is very good practice to not have side effects
in warnings, as people, not compilers, like to remove them.

	Regards
		Oliver


