From: Rajesh <rajeshsg@netcore.co.in>
Subject: Re: Adaptec 7901A-iROC - aic79xx
Date: Mon, 29 Sep 2003 11:44:30 +0530
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F77CDC6.6000104@netcore.co.in>
References: <3F73E601.5060300@netcore.co.in> <690660000.1064595283@aslan.btc.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [202.162.229.13] ([202.162.229.13]:51160 "EHLO
	uucp3.netcore.co.in") by vger.kernel.org with ESMTP id S262827AbTI2GJS
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Sep 2003 02:09:18 -0400
Received: from uucp1.netcore.co.in (unknown [192.168.2.1])
	by uucp3.netcore.co.in (Postfix) with ESMTP id 9534C3C795
	for <linux-scsi@vger.kernel.org>; Mon, 29 Sep 2003 11:35:34 +0530 (IST)
Received: (from uucp@localhost)
	by uucp1.netcore.co.in (8.11.0/8.8.7) with UUCP id h8T6IS931584
	for linux-scsi@vger.kernel.org; Mon, 29 Sep 2003 11:48:28 +0530
Received: from netcore.co.in ([192.168.2.30])
	by netserv.ho.netcore.co.in (8.11.6/8.11.2) with ESMTP id h8T64Pt23876
	for <linux-scsi@vger.kernel.org>; Mon, 29 Sep 2003 11:34:25 +0530
In-Reply-To: <690660000.1064595283@aslan.btc.adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Justin T. Gibbs wrote:

>>Hi List,
>>
>>
>>     I am having on-board Adaptec 7901-iROC (SCSI Raid Controller).  I am
>>not able to get it working even with latest 2.4.22 kernel. Kernel 2.4.22
>>seems to have latest source from http://people.freebsd.org/~gibbs/linux/
>>of the driver. Is this controller supported by aic79xx???  Or else i have
>>to try something else???
>>    
>>
>
>Disable HostRAID via SCSI-Select.  The aic79xx driver does not support
>HostRAID.
>
>--
>Justin
>
>  
>

Justin,

      Thanks, it worked. Now i have my favourite OS running on my system :-)


Rajesh

----------------------------------------------------------------

NETCORE SOLUTIONS *** Ph: +91 22 5662 8000 Fax: +91 22 5662 8134

MailServ: Email, IM, Proxy, Firewall, Anti-Virus, LDAP
Fleximail: Mail Storage, Management and Relaying
http://netcore.co.in

Emergic Freedom: Linux-based Thin Client-Thick Server Computing
http://www.emergic.com

BlogStreet: Blog Profiles, RSS Ecosystem, Blog Tops, Search
http://www.blogstreet.com

Rajesh Jain's Weblog on Technology: http://www.emergic.org
----------------------------------------------------------------


