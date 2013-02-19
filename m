From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v2 1/3] Encapsulate scsi_do_report_luns
Date: Tue, 19 Feb 2013 08:15:01 +0100
Message-ID: <51232675.4090104@acm.org>
References: <1361214952-28978-1-git-send-email-revers@redhat.com> <1361214952-28978-2-git-send-email-revers@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jacques.telenet-ops.be ([195.130.132.50]:55984 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700Ab3BSHPF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Feb 2013 02:15:05 -0500
In-Reply-To: <1361214952-28978-2-git-send-email-revers@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rob Evers <revers@redhat.com>
Cc: linux-scsi@vger.kernel.org

On 02/18/13 20:15, Rob Evers wrote:
> +	/*
> +	 * bytes 6 - 9: length of the command.
> +	 */
> +	scsi_cmd[6] = (unsigned char) (length >> 24) & 0xff;
> +	scsi_cmd[7] = (unsigned char) (length >> 16) & 0xff;
> +	scsi_cmd[8] = (unsigned char) (length >> 8) & 0xff;
> +	scsi_cmd[9] = (unsigned char) length & 0xff;

Have you considered using put_unaligned_be32() here ?

Bart.
