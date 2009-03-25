From: Konrad Rzeszutek <konrad@virtualiron.com>
Subject: Re: mptfusion: how to Find a WWN of a logged in Fibre Channel
	initiator?
Date: Wed, 25 Mar 2009 10:20:09 -0400
Message-ID: <20090325142009.GA26612@mars.virtualiron.com>
References: <49C78598.9090700@mpstor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host-216-57-134-2.customer.veroxity.net ([216.57.134.2]:20580
	"EHLO mars.virtualiron.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1762781AbZCYOWf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Mar 2009 10:22:35 -0400
Content-Disposition: inline
In-Reply-To: <49C78598.9090700@mpstor.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Benjamin ESTRABAUD <be@mpstor.com>
Cc: linux-scsi@vger.kernel.org

On Mon, Mar 23, 2009 at 12:50:32PM +0000, Benjamin ESTRABAUD wrote:
> Hi,
>
> I am wondering if anyone would know the answer to the following question:
>
> From the LSI mpt fusion driver, is there a way to extract the WWN of a 
> logged in Fibre Channel initiator or a known SAS initiator? I can get its 
> Initiator Index from the reply word... is there a way to use this to return 
> the WWN from an internal table of logged on/known initiators?

find /sys -name sas_address
or
find /sys -name port_name

Doesn't help?

>
> I've been trying for a good while now to do this but no luck whatsoever, I 
> would really appreciate if someone who had an idea on how to do this could 
> reply. Thanks a million in advance!
>
> Ben - MPSTOR.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
