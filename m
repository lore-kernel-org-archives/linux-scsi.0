From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH] minimal SAS transport class
Date: Tue, 23 Aug 2005 19:55:37 -0400
Message-ID: <430BB779.2060209@adaptec.com>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7A40@xbl3.ma.emulex.com> <20050822045502.GA7147@lists.us.dell.com> <430A05F2.10009@adaptec.com> <20050822215316.GB8083@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:61645 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S932495AbVHWXzl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Aug 2005 19:55:41 -0400
In-Reply-To: <20050822215316.GB8083@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: Matt Domsch <Matt_Domsch@dell.com>, James.Smart@Emulex.Com, hch@lst.de, jejb@steeleye.com, ltuikov@yahoo.com, Eric.Moore@lsil.com, andrew.patterson@hp.com, linux-scsi@vger.kernel.org

On 08/22/05 17:53, Mike Anderson wrote:
> Luben Tuikov <luben_tuikov@adaptec.com> wrote:
> 
>>Yes, that's cool.
>>
>>How about specifying the LU label _and_ the FS label to "root="?
>>
>>root=[<disk label>:]<fs label>
>>
>><disc label> :=
>>	WWN,
>>	HCIL,
>>	Funky name 1,
>>	Funky name 2.
>>
>><fs label> :=
>>	filesystem specific label.
>>	
>>All those labels are tacked onto the LU, and are provided by
>>various layers: transport, LLDD, vendor, manufacturer, etc, etc, etc.
>>
> 
> 
> What is the difference between this disk label and what you can do with a
> udev rules file today?

Where does udev get its label?

	Luben

> On SUSE today you can boot a system using a udev
> created name "root=/dev/disk/by-id/351234560000007d0" which is one example
> of using the udev rules "PROGRAM" call to generate a name. You should be
> able to cover all your examples with a call-out program knowledgeable of
> where to find this disk label information and create a device node for
> them.
> 
> -andmike
> --
> Michael Anderson
> andmike@us.ibm.com
> 

