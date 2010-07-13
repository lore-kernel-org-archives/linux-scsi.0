From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: be2iscsi: Adding features to be2iscsi -V2
Date: Tue, 13 Jul 2010 02:26:14 -0500
Message-ID: <4C3C1516.4000708@cs.wisc.edu>
References: <20100712174716.GA11289@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:35615 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755479Ab0GMHXA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Jul 2010 03:23:00 -0400
In-Reply-To: <20100712174716.GA11289@serverengines.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jayamohan Kalickal <jayamohank@serverengines.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@suse.de

On 07/12/2010 12:47 PM, Jayamohan Kallickal wrote:
> Hi
>
>    	These set of patches have been made on
> git://git.kernel.org/pub/scm/linux/kernel/git/konrad/ibft-2.6.git
>

You should not make the patches over that tree, because it is missing 
some be2iscsi patches. You should have just brought the needed boot 
patches into scsi-misc or linus's tree or scsi-rc-fixes. The first 
couple of patches do not apply.
