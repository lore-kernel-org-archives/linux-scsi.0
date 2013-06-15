From: Andy Grover <andy@groveronline.com>
Subject: Re: TPG_Authentication style not supported by kernel?
Date: Fri, 14 Jun 2013 17:04:54 -0700
Message-ID: <51BBAFA6.9090708@groveronline.com>
References: <CAFDa5Q1AfZuuDZoACZZGDqkZa9Ln73y576bTfNiV_vfLsajv7A@mail.gmail.com> <1371245691.15314.120.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pigeon.buunabet.com ([198.145.19.6]:41476 "EHLO
	pigeon.buunabet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752380Ab3FOAOo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Jun 2013 20:14:44 -0400
In-Reply-To: <1371245691.15314.120.camel@haakon3.risingtidesystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Dax Kelson <dkelson@gurulabs.com>, target-devel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, Jerome Martin <jxm@risingtidesystems.com>

On 06/14/2013 02:34 PM, Nicholas A. Bellinger wrote:
> Hi Dax,
>
> On Tue, 2013-06-11 at 16:21 -0600, Dax Kelson wrote:
>> I have a fully updated Fedora 18 box with kernel 3.9.4-200.
>>
>> I'd like to use the technique listed here:
>>
>> http://linux-iscsi.org/wiki/ISCSI#TPG_Authentication
>>
>> Specifically, "Setting up authentication information for every single
>> initiator separately can be cumbersome, so targetcli provides the
>> capability to define common login information for all Endpoints in a
>> TPG. As a result, all initiators connecting to that TPG can use the
>> same login credentials."
>>
>> The only problem is that the kernel doesn't appear to support this?? I
>> don't see an "auth" directory under the tpgt directory.
>>
>> Help?
>>
>
> So TPG authentication has not been included into mainline + targetcli as
> of yet, so it actually should not be on the wiki..
>
> That said, it's an TODO item on my list to add proper support for v3.11
> -> v3.12 mainline kernel code.
>
> --nab

git://linux-iscsi.org/targetcli.git
commit ab442938d5516e8748b4a323f991b6a8aa5bab5a
Author: Jerome Martin <jxm@risingtidesystems.com>
Date:   Thu Dec 15 13:33:20 2011 +0100

     Added generic auth support in ui_node

     * Replaces Node ACL ad-hoc auth support
     * Allows auth support in TPGT (recently added in iSCSI)


Actually support was added to targetcli in Dec 2011.

Obviously this is another feature that has been in your proprietary 
product for *years*. Can you at least be upfront with us on what the 
features you have implemented but not yet shared publicly are, and what 
your schedule for open-sourcing them is? Or at least highlight the 
differences on the linux-iscsi.org website? Because people look at that 
website and assume those features are in the mainline Linux kernel.

-- Andy

