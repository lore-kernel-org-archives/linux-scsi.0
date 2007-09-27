From: <Patrick_Boyd@Dell.com>
Subject: RE: generating a Linux WWN?
Date: Thu, 27 Sep 2007 09:16:13 -0500
Message-ID: <CE7B1A4EF22E704CBFFD9A35BA5C822252505C@ausx3mpc110.aus.amer.dell.com>
References: <46FB8024.8040807@garzik.org> <46FBB86B.8000206@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ausc60pc101.us.dell.com ([143.166.85.206]:65097 "EHLO
	ausc60pc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121AbXI0O0p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Sep 2007 10:26:45 -0400
Content-class: urn:content-classes:message
In-Reply-To: <46FBB86B.8000206@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com, jeff@garzik.org
Cc: linux-scsi@vger.kernel.org

Unfortunately, it looks like IEEE doesn't have any OID's registered for
Linux or other reserved areas
(http://standards.ieee.org/regauth/oui/oui.txt). However, it does look
like they go in order... so maybe if you used an OID of 0xFFFFFF you
could at least guarantee that you didn't conflict with any company's SAS
WWNs.

Patrick Boyd

James Smart wrote:
>Uh, although this may work very well for small constrained configs, as
one
>who debugs larger environments (and things always grow or get connected
in
>ways you don't expect), depending on a random number for uniqueness
makes
>me very unsettled. Debugging that small-percentage potential, when/if
it
>does occur can be an absolute nightmare with all kinds of weird
behavior.
>Rarely will you solve it from the context of a single server. There are
>lots of ways to cheat, but I believe they all have to be based on some
>small part that is guaranteed to be unique (like the IEEE id's).
>
>-- james s
>
>Jeff Garzik wrote:
>> Is there an accepted way to generate a SAS address, when the adapter 
>> does not supply one (NVRAM invalid or missing, etc.)?
>> 
>> Unless somebody complains, I was just planning to use 
>> get_random_bytes().  But maybe Linux has an IEEE id we can use, to
make 
>> the practice a bit more legitimate and avoid stomping on others?  Or
an 
>> IEEE id specifically designed for generated-address purposes?
>> 
>>     Jeff
>> 
>> 
>> 
>> -
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi"
in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> 
>-
>To unsubscribe from this list: send the line "unsubscribe linux-scsi"
in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
