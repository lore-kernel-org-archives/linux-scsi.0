From: Jack Hammer <jack_hammer@adaptec.com>
Subject: Re: Updated Patch for ServeRAID V7.12.02
Date: Wed, 27 Jul 2005 08:20:43 -0400
Message-ID: <42E77C1B.6050009@adaptec.com>
References: <42E646B1.7080503@adaptec.com> <20050726201149.6e685a57.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:28390 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S262215AbVG0MWd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Jul 2005 08:22:33 -0400
In-Reply-To: <20050726201149.6e685a57.rdunlap@xenotime.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: randy_dunlap <rdunlap@xenotime.net>
Cc: linux-scsi@vger.kernel.org

Randy,

1.) Install Thunderbird extension "Edit Config Files 1.3".

2.) Add these two lines in user.js :

    pref("mailnews.send_plaintext_flowed", false);    // RFC 2646
    pref("mailnews.display.disable_format_flowed_support", true);

3.) Set "Wrap plain text messages at 0 characters" under "Options / Composition"

Thanks to Luben Tuikov, who guided me through all this. If you have any 
further questions, he is probably the guy to ask ...

Jack



On 7/26/2005 11:11 PM, randy_dunlap wrote:
> On Tue, 26 Jul 2005 10:20:33 -0400 Jack Hammer wrote:
> 
> 
>>I switched to Thunderbird email, so the line wrapping caused by Outlook
>>should be resolved here.
> 
> 
> for the rest of us, how do you put a patch inline (not as an
> attachment) with thunderbird?  have they added that capability
> recently?  It would certainly go a long way to making thunderbird
> usable for kernel patches...
> 
> Maybe it helps not to use tabs in the source files very much?
> 
> Thanks,
> ---
> ~Randy
> 

