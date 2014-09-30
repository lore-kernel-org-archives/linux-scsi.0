From: Jerome Martin <jxm@netiant.com>
Subject: Re: targetcli do not show iscsi
Date: Tue, 30 Sep 2014 17:26:27 +0200
Message-ID: <542ACBA3.4020703@netiant.com>
References: <542A6F44.3070802@gmail.com> <542A7037.6050909@netiant.com> <542A722E.5030109@gmail.com> <542A73BE.2080501@netiant.com> <542A75F1.8070706@gmail.com> <542A77D6.4090109@netiant.com> <542A7ADD.3040804@gmail.com> <542A7BC9.2050708@netiant.com> <542ACA6C.104@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:52903 "EHLO
	relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782AbaI3P0c (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Sep 2014 11:26:32 -0400
In-Reply-To: <542ACA6C.104@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Grover <agrover@redhat.com>, Luigi Tarenga <luigi.tarenga@gmail.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, "Nicholas A. Bellinger" <nab@linux-iscsi.org>


On 09/30/2014 05:21 PM, Andy Grover wrote:
> iscsi is not a supported fabric on rhel/centos 6. Only FCoE uses LIO.
> scsi-target-utils (tgt) is the supported iscsi target on rhel6. rhel7
> uses LIO for both, as does Fedora.

Ha, that explains it then. Thanks Andy.
