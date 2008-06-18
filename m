From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH/RFC v3] allow userspace to modify scsi command filter
 on per device basis
Date: Wed, 18 Jun 2008 10:55:28 -0400
Message-ID: <485921E0.9000103@emulex.com>
References: <6cf6b73e0806152249r19cb405ct9d5a33960e619348@mail.gmail.com>	<20080616151328Q.fujita.tomonori@lab.ntt.co.jp>	<6cf6b73e0806160222g19d7229dl6a650e13ab36c03b@mail.gmail.com> <20080618051447L.fujita.tomonori@lab.ntt.co.jp> <48583074.8010909@redhat.com> <48584252.5030901@interlog.com>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:44875 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbYFRO5O (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Jun 2008 10:57:14 -0400
In-Reply-To: <48584252.5030901@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: Peter Jones <pjones@redhat.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, adel.gadllah@gmail.com, matthew@wil.cx, linux-scsi@vger.kernel.org, jens.axboe@oracle.com


Douglas Gilbert wrote:
> IMO all command filtering should be dropped **. 
> 
> ...  If the user has sufficient permissions
> on the pass-through device, let them send commands, simple.
> Let udev probe the device, and set its permissions according
> to udev's policies. Let the target device do command filtering!

I second Doug's opinion.

-- james s
