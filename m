From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: Re: [PATCH 2/3] - mpt fusion -
Date: Fri, 14 Apr 2006 18:45:24 -0600
Message-ID: <005d01c66025$e2cbeeb0$231015ac@ericmoore>
References: <664A4EBB07F29743873A87CF62C26D70080B51@NAMAIL4.ad.lsil.com> <20060414010405.GB23580@infradead.org> <002c01c65f69$319745c0$201015ac@ericmoore> <1145026079.3520.12.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:19686 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1751471AbWDOApW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Apr 2006 20:45:22 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

On Friday, April 14, 2006 8:47 AM, James Bottomley wrote:


> On Thu, 2006-04-13 at 20:14 -0600, Moore, Eric wrote:
>> Christoph can you help me on this, please?
>> The original sas_rphy_add() function from three weeks back works for mptsas.
>> I'm not sure why that change was made, and whether reverting back to its orginal code
>> would break the other sas driver.  
> 
> Does this fix the problem?
> 

I think this will fix it.  I appears to do what the previous sas_rphy_add() had done, so I'm happy.
However, today was a holiday, and I went skiing one more time. So I hadn't tested it out yet.   
I noticed that you've submitted this with your scsi bug fix's to Linus, so thanks.

Can we get that [PATCH 3/3] fusion patch in for rc2?    I had fix some bugs in the handling 
reporting of raid components when power is turned off and on to the devices.   These are critical fix's.

Eric

