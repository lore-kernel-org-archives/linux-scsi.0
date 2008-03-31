From: dv9999 <dyu9999@yahoo.com>
Subject: REQ_FAILFAST flag in async calls
Date: Mon, 31 Mar 2008 10:06:41 -0700 (PDT)
Message-ID: <16397218.post@talk.nabble.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kuber.nabble.com ([216.139.236.158]:49733 "EHLO
	kuber.nabble.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755830AbYCaRGl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Mar 2008 13:06:41 -0400
Received: from isper.nabble.com ([192.168.236.156])
	by kuber.nabble.com with esmtp (Exim 4.63)
	(envelope-from <lists@nabble.com>)
	id 1JgNSz-00020k-4n
	for linux-scsi@vger.kernel.org; Mon, 31 Mar 2008 10:06:41 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Hi Linux kernel scsi experts, 

I would appreciate some information from you or dm-devel on the following:

I am wondering how to pass and support REQ_FAILFAST in scsi_execute_async
function in latest kernel. In sync mode (scsi_execute), caller can pass this
as flag parameter, but how this is done in case of scsi_execute_async?

Thanks.
Dave

Note: the comment below is not accurate in kernel code...

/**
 * scsi_execute_async - insert request
 * @sdev:       scsi device
 * @cmd:        scsi command
 * @cmd_len:    length of scsi cdb
 * @data_direction: data direction
 * @buffer:     data buffer (this can be a kernel buffer or scatterlist)
 * @bufflen:    len of buffer
 * @use_sg:     if buffer is a scatterlist this is the number of elements
 * @timeout:    request timeout in seconds
 * @retries:    number of times to retry request
 * @flags:      or into request flags
 **/
int scsi_execute_async(struct scsi_device *sdev, const unsigned char *cmd,
                       int cmd_len, int data_direction, void *buffer,
unsigned bufflen,
                       int use_sg, int timeout, int retries, void *privdata,
                       void (*done)(void *, char *, int, int), gfp_t gfp)





-- 
View this message in context: http://www.nabble.com/REQ_FAILFAST-flag-in-async-calls-tp16397218p16397218.html
Sent from the linux-scsi mailing list archive at Nabble.com.

