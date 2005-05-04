From: kylin <fierykylin@gmail.com>
Subject: PCI express equipment
Date: Wed, 4 May 2005 19:51:12 +0800
Message-ID: <87ab37ab05050404516a2bcc40@mail.gmail.com>
Reply-To: kylin <fierykylin@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zproxy.gmail.com ([64.233.162.195]:38054 "EHLO zproxy.gmail.com")
	by vger.kernel.org with ESMTP id S261627AbVEDLvM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 May 2005 07:51:12 -0400
Received: by zproxy.gmail.com with SMTP id 18so256742nzp
        for <linux-scsi@vger.kernel.org>; Wed, 04 May 2005 04:51:12 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On one hand ,hardwarely,as it is always said, PCIE provides the
superexcellent performance

comparing with the PCI and PCI -X 
On the other ,softwarely,in most the application scenarios i have met
, the PCIE equipment will

have to use the pci-compatible driver first in linux.
because the Configuration head is pci compatible in the first 256 byte ,
it is allowed and really works. 
i know if we use the conventional Device Driver for pcie equipment,
the advanced option such as MSI ,Flow Control ,TC ,VC and hotplug are
unavailable, i also know

that the speed is mainly the problem of Bandwidth and Clocking. Still
i know that the Trafic

control mechanism is good for the arbitration and thus improve the
performance just like the

TCP protocol ways.
So my conclusion is :
the conventional Device driver will not be the bottle neck of the PCIE
performance as long as

only speed is concerned ,and the advanced options are only
Application-related.
here allow me just compare it with the network protocol ,
oh ,i just use the IP protocol ,with out the TCP /UDP way.
is that right ?or any wise can give some advice and  


-- 
we who r about to die,salute u!
