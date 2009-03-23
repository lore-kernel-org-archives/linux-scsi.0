From: Benjamin ESTRABAUD <be@mpstor.com>
Subject: mptfusion: how to Find a WWN of a logged in Fibre Channel initiator?
Date: Mon, 23 Mar 2009 12:50:32 +0000
Message-ID: <49C78598.9090700@mpstor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from server009.hostspectrum.com ([206.123.101.24]:38998 "EHLO
	server009.hostspectrum.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755612AbZCYHAQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Mar 2009 03:00:16 -0400
Received: from [91.123.228.52] (helo=[10.0.2.67])
	by server009.hostspectrum.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.69)
	(envelope-from <be@mpstor.com>)
	id 1Lljb2-00070W-Q2
	for linux-scsi@vger.kernel.org; Mon, 23 Mar 2009 07:49:40 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I am wondering if anyone would know the answer to the following question:

 From the LSI mpt fusion driver, is there a way to extract the WWN of a 
logged in Fibre Channel initiator or a known SAS initiator? I can get 
its Initiator Index from the reply word... is there a way to use this to 
return the WWN from an internal table of logged on/known initiators?

I've been trying for a good while now to do this but no luck whatsoever, 
I would really appreciate if someone who had an idea on how to do this 
could reply. Thanks a million in advance!

Ben - MPSTOR.
