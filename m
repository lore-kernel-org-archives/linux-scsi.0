From: Gert Vervoort <gert.vervoort@hccnet.nl>
Subject: Re: [PATCH] Re: 2.5.67: ppa driver & preempt == oops
Date: Wed, 16 Apr 2003 20:03:22 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E9D9AEA.2090705@hccnet.nl>
References: <3E982AAC.3060606@hccnet.nl> <1050172083.2291.459.camel@localhost> <3E993C54.40805@hccnet.nl> <1050255133.733.6.camel@localhost> <3E99A1E4.30904@hccnet.nl> <20030415120000.A30422@beaverton.ibm.com> <3E9C6F10.10001@hccnet.nl> <20030415144051.A31514@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.hccnet.nl ([62.251.0.13]:20890 "EHLO smtp.hccnet.nl")
	by vger.kernel.org with ESMTP id S264507AbTDPRuR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Apr 2003 13:50:17 -0400
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: tconnors@astro.swin.edu.au, Robert Love <rml@tech9.net>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

>
>
>
>Can you dd to and from the media OK?
>  
>
Same effect as mount, now dd is stuck in the "D" state, dd if=/dev/sda 
of=/tmp/kw:

[root@viper root]# ps -ax |grep dd
  985 tty1     D      0:00 dd if /dev/sda of /tmp/kw
 1041 tty2     S      0:00 grep dd
[root@viper root]#


   Gert

