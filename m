From: david@lang.hm
Subject: deterministic scsi order with async scan
Date: Wed, 15 Jul 2009 18:09:22 -0700 (PDT)
Message-ID: <alpine.DEB.1.10.0907151801040.9159@asgard>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.lang.hm ([64.81.33.126]:33849 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756831AbZGPBJX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Jul 2009 21:09:23 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

is there any way to get deterministic device ordering with scsi async 
scanning?

currently (2.6.30) it seems that the various scsi busses are loaded in the 
order that they are detected, which can vary from boot to boot depending 
on how long it takes for the card to initialize.

would it be possible to detect the cards/drives, but not register them 
until all the detection is complete so that they can be registered in a 
deterministic order?

having two drives on two different controllers swap positions from boot to 
boot makes it very painful. yes I can make an initrd that fixes this up in 
user space by examining each drive and creating links to re-order them, 
but this is a lot of work to fix randomization that can be prevented in 
the first place.

David Lang
