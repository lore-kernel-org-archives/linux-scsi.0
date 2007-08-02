From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] Some cosmetic changes to QlogicPTI SCSI driver
Date: Thu, 02 Aug 2007 09:59:15 +0300
Message-ID: <46B180C3.1020408@panasas.com>
References: <Pine.LNX.4.61.0707311948370.5707@mtfhpc.demon.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:14122 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754747AbXHBG7U (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Aug 2007 02:59:20 -0400
In-Reply-To: <Pine.LNX.4.61.0707311948370.5707@mtfhpc.demon.co.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Fortescue <mark@mtfhpc.demon.co.uk>
Cc: linux-scsi@vger.kernel.org

Mark Fortescue wrote:
> 
> I must get an email client that does not mangle patches. Any 
> recomendations ?
> 

If you want to use Thunderbird than you must do two things:

1. "Edit"/"Preferences"/"Composition"/"General" tab/
    Wrap plain text messages at | 0 | characters.
    (Yes now you must format line length yourself)

2. in about:config
   mailnews.send_plaintext_flowed = false
   mailnews.display.disable_format_flowed_support = true
   and also 
   mailnews.plaintext_domains = vger.kernel.org

 And than set every thing for Text-format and not HTML

Boaz
