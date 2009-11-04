From: John Hughes <john@Calva.COM>
Subject: Re: ses enclosure stuff not working with Promise Vtrak J610S JBOD
Date: Wed, 04 Nov 2009 17:54:23 +0100
Message-ID: <4AF1B1BF.1060702@Calva.COM>
References: <4AF17AD3.6060909@Calva.COM> <4AF1A2F0.7060201@Calva.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from oceanic.CalvaEDI.COM ([81.252.197.184]:36708 "EHLO
	oceanic.CalvaEDI.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756771AbZKDQyU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Nov 2009 11:54:20 -0500
In-Reply-To: <4AF1A2F0.7060201@Calva.COM>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Hughes <john@Calva.COM>
Cc: linux-scsi@vger.kernel.org

John Hughes wrote:
> Well the "locate" light does work, you just have to first write zero, 
> then one.
>
> I.E.
>
> echo 0 > locate
> echo 1 > locate
>
> starts the light flashing.
This appears to be a problem with the Promise firmware; once a zero has 
been written to "locate" then it works as expected until the next time 
the promise is power-cycled.

