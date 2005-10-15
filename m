From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH 0/3] libata: scsi error handling, encore
Date: Sat, 15 Oct 2005 13:46:47 +1000
Message-ID: <43507BA7.6090406@torque.net>
References: <43490BC8.9060504@torque.net> <434919E4.1080601@pobox.com> <435069E3.90306@torque.net> <43506AA3.3030502@pobox.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:21485 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S1751052AbVJODpv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Oct 2005 23:45:51 -0400
In-Reply-To: <43506AA3.3030502@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, htejun@gmail.com, russb@emc.com

Jeff Garzik wrote:
> Douglas Gilbert wrote:
> 
>> Six days have passed and "git pull ..../libata-dev" still
>> does not reflect these changes. Am I doing something
>> wrong? Should I wait before submitting more changes?
> 
> 
> Your changes are committed to the 'upstream' branch.  Maybe you need to do
>     git pull $url upstream

Jeff,
Thanks, indeed I do. Obviously the fact the 'upstream'
was the active branch in the destination directory was
not sufficient. So do I need to do both
'git pull $url' and 'git pull $url upstream' or is
the latter sufficient?

"git" does seems an appropriate name :-)

Doug Gilbert

