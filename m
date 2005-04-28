From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: regarding 2.6.9-6 diskdump driver
Date: Thu, 28 Apr 2005 08:51:06 -0400
Message-ID: <1114692667.6068.74.camel@localhost.localdomain>
References: <009917BCC3B63543BA9BCD212F9D177401BF95DB@bgeexc01.asiapacific.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from s-utl01-lapop.stsn.com ([12.129.240.11]:40428 "HELO
	s-utl01-lapop.stsn.com") by vger.kernel.org with SMTP
	id S262229AbVD2JuV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Apr 2005 05:50:21 -0400
In-Reply-To: <009917BCC3B63543BA9BCD212F9D177401BF95DB@bgeexc01.asiapacific.cpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Jayashree, . (STSD)" <jayashree@hp.com>
Cc: linux-scsi@vger.kernel.org

On Tue, 2005-04-26 at 18:20 +0530, Jayashree, . (STSD) wrote:
> Hi,
> 
> Currently I want to use diskdump functionality of aic7xxx.o driver.  I
> am using RHEL 4 Update 1 (kernel 2.6.9-6.37). I am getting an error
> while dumping the core.  I have few issues, please help me out resolving
> the following issues or let me know whether I am using correct version
> of drivers.

You're better off using kexec based dumping, that means you can dump to
filesystems and lvm and such too.

If you really insist on using that weird hack then better report your
issues to the authors of said hack :)




