From: Tom Coughlan <coughlan@redhat.com>
Subject: Re: Megaraid corruption?
Date: Thu, 09 Dec 2004 09:14:51 -0500
Message-ID: <1102601691.14284.16798.camel@bianchi.boston.redhat.com>
References: <1102558665.31354.22.camel@TroysLinux.verari.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:12198 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S261322AbULIOQH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Dec 2004 09:16:07 -0500
In-Reply-To: <1102558665.31354.22.camel@TroysLinux.verari.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: res1uo0c@verizon.net
Cc: linux-scsi@vger.kernel.org

On Wed, 2004-12-08 at 21:17, Troy Klein wrote:
> I am attempting to find out why I am having data corruption problems on
> my megaraid2 driver and not on megaraid.  The system is a 32-bit Xeon
> with a LSI 150-6 SATA controller running Redhat EL 3.0AS.  When I am
> running megaraid I can write data, read data, and modify data and get NO
> corruption.  With megaraid2 I get data corruption with tar, rsync, and
> scp.

Are there messages in /var/log/messages that correspond to the timeframe
of the corruption? 

