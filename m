From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 2/8] iscsi_transport: Additional parameters for net settings
Date: Fri, 31 May 2013 09:26:44 -0500
Message-ID: <51A8B324.8010106@cs.wisc.edu>
References: <3FC4AB8B47ECD546BCD4B361A64BEACD30EEFEA8@avmb3.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:51682 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751880Ab3EaO0y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 31 May 2013 10:26:54 -0400
In-Reply-To: <3FC4AB8B47ECD546BCD4B361A64BEACD30EEFEA8@avmb3.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Cc: "jbottomley@parallels.com" <jbottomley@parallels.com>, linux-scsi <linux-scsi@vger.kernel.org>, Lalit Chandivade <lalit.chandivade@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>, Harish Zunjarrao <harish.zunjarrao@qlogic.com>

On 05/28/2013 06:36 AM, Vikas Chaudhary wrote:
> 
> 
> -----Original Message-----
> From: Mike Christie <michaelc@cs.wisc.edu>
> Date: Tuesday 28 May 2013 2:19 PM
> To: Vikas <vikas.chaudhary@qlogic.com>
> Cc: "jbottomley@parallels.com" <jbottomley@parallels.com>, scsi
> <linux-scsi@vger.kernel.org>, Lalit Chandivade
> <lalit.chandivade@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>, Harish
> Zunjarrao <harish.zunjarrao@qlogic.com>
> Subject: Re: [PATCH 2/8] iscsi_transport: Additional parameters for net
> settings
> 
>> Come on man, same comments as last patches like this :) Could you use
>> the same names that we currently use for existing params?
>>
>> Check for the inorder ones and the ones where we use en instead of
>> enabled for the postfix. Also check the others.
> 
> If we understand correctly you are suggesting to change macro postfix from
> EN to ENABLED as in attached patch "iscsi_net_param-fix1.patch".
> But we think changing old macro postfix from ENABLED to EN is better way
> to fix it.

I meant the second one. Also in the patch some of the names of sysfs
files and variables use _enabled, but for sysfs we use _en and then some
names just do not match at all.

For example some iface names like data_pdu_inorder_enabled would be
pdu_inorder_en and the data_seq_inorder_enabled would be
dataseq_inorder_en to match what the naming used in the session. There
are others that need to match like immediate data, etc. Check them
before you resubmit.
