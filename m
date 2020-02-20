Return-Path: <SRS0=qpW3=4I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FE88C11D0B
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Feb 2020 16:02:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 323EB24672
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Feb 2020 16:02:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728601AbgBTQCb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 20 Feb 2020 11:02:31 -0500
Received: from mx2.suse.de ([195.135.220.15]:44352 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728410AbgBTQCa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 20 Feb 2020 11:02:30 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id E8B81ADD9;
        Thu, 20 Feb 2020 16:02:28 +0000 (UTC)
From:   Antonio Larrosa <alarrosa@suse.de>
Subject: ioctl seems to change errno behaviour in 5.6.0rc2
Autocrypt: addr=alarrosa@suse.de; prefer-encrypt=mutual; keydata=
 mQGiBD8pc34RBADax1+cDEPv04aOUxFQ1N947ZeER5rbOwA4THsMnFbdJd3cQealCk3SkGx/
 1CkHCAp8MKmIFWg73zDWBjyWJ4OMPkfhsSZRSW2LgQ6XAEylnZJjrmldBOF/6mrvaGhtTtrs
 F0FXsqO12QpljCb5O0pqKZbsUcaZETqkFcMM9/9ijwCgxVq/f3znU/gbfKcKs2dKwWdD4UkE
 AKQZoP0WIlGplrWLd+FVY0ElvxPqamKrGLsEnoSfjk7N+hjo5QqWRhNMhjhIE+ghur2EP9lD
 PmCHXuXuPfg9O26SdW3ea6zxeUsj7tfsN3loEbTZ45oEULwVv6FM3Jnk7sYr8+GwUoar0ZjY
 W+MtEnV5tLLQv9v1b72QT4YDrpAiA/9W7FNMmN8g6a9YM1vzjUO17xEA0xOe0UgraiFe3Ag4
 IMKoICvll666LjHCwqATjYtYoZ9Bvmc4EMyAHyIlj3/gwQGTfabmNzt70uUu0/+rmdF683KK
 48riI/tEw4QWDQvKShSuVNlwa8Q+2ZhLGTY3xByHBvU9yT6PS9398gobZbQrQW50b25pbyBM
 YXJyb3NhIEppbcOpbmV6IDxhbGFycm9zYUBzdXNlLmRlPohjBBMRAgAjBQJSAKP/AhsDBwsJ
 CAcDAgEGFQgCCQoLBBYCAwECHgECF4AACgkQ3mWkZZAItZAMJACfePOU9E2m5r8UKeuhoOUV
 ov8VE+AAoLfpxeB3YJAD5Sk8g0XEQ6U/IRSnuQINBD8pc4cQCACaRlpl+4QHEOcT4BdHFvwl
 rUYIPkHkQGqFQdBx1+9lo7F1FMRVnqe1HF4MTNPaWIjcze3TbeTh5XMhNgdT3zEyilPu3oQ7
 HcKvBigQOqfzLLhs3ay+2A+Rhv2HJd+V8RUb5go0SK4VnOyFtmA4P7t805HYVvLiV9c8dyOt
 kpuazNKqzpmz0bWIcoTli0FWekPkEmzwiU0AcRPO0ftRYVv4oIf/Rf7ReeQN1EK2gYRc902R
 W6mVRZthfllUXtAVb1M/hXTagu9s/jXYngE7ld7FtJ4ZicFwkrx14ko/08ZnbY/Vpfgu4QU3
 ze72Dl/4gNksLKIM47V+xprtMyNr5rg7AAMFB/9KPipiSB6Kxh8loHb9Wki2SzPnK5JQxU2s
 IBYXa88M8az2qjq3SkrBP7ckHGiqswzIF70gdUYrH4q7jNMpAikI1ABo+sHnCMYRgamZnfft
 EJSsrGKhnj0+VsYTlf9d+YxoWHfi4bkhidySD7evA/kmW4lQoX8zTjw1sqgqIFxeBmYizhMy
 prlxBBc7AGPy+ZSH0kvgH3XgiAz5+iUw5XibccJha7SfHztmMM/swxTQNLSp0bOyWfrR56lw
 D43kfUVx0SFSy/YqtEUN/PwW0n5pxa5mOmZMdFwKih/31kL2F7EwN5pmN+D6ECkKCiJMeYCn
 YEq8X+S1iZzz8rms4lUYiEYEGBECAAYFAj8pc4cACgkQ3mWkZZAItZA0QQCdGIzCpf1tHypW
 +d3i2kPyMOeZ80MAmwZBSIo8R9KruBK9rohkjiDfFDvV
To:     Doug Gilbert <dgilbert@interlog.com>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-scsi@vger.kernel.org
Message-ID: <68516393-f24a-dbb5-4c81-99fb1b70bb6f@suse.de>
Date:   Thu, 20 Feb 2020 17:02:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------9444AF95A2D512A04BF03B9C"
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------9444AF95A2D512A04BF03B9C
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

Hello,

I noticed cdparanoia stopped working with kernel 5.6.0rc2 while it worked fine
with 5.5.2 .

Running as root `cdparanoia -v -d /dev/sr0 [0]` with 5.6.0rc2, gives the
following errors:

Testing /dev/sr0 for SCSI/MMC interface
        no SG_IO support for device: /dev/sr0
Error trying to open /dev/sga exclusively (No such file or directory).

I checked that the sg module is loaded with both kernels and also did a diff of
the lsmod output with both kernels and didn't find anything suspicious.

After some tests, I did a small c application using code from cdparanoia where
it can be seen that the ioctl(fd, SG_IO, &hdr) call returns EINVAL in errno with
the 5.5.2 kernel but returns EFAULT with 5.6.0rc2 .

The code is attached and can be built just with `gcc test.c -o test` (note it's
hardcoded in main to use /dev/sr0, so it doesn't have any parameter).

Note that I'm not a cdparanoia developer (in fact, it seems to have been
unmaintained for many years), but I thought it might be interesting to report an
ioctl that changes the behaviour in different kernels.

Greetings,

-- 
Antonio Larrosa

--------------9444AF95A2D512A04BF03B9C
Content-Type: text/x-csrc; charset=UTF-8;
 name="test.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="test.c"

#include <stdio.h>
#include <unistd.h>
#include <errno.h>
#include <fcntl.h>
#include <string.h>
#include <sys/ioctl.h>
#include <scsi/sg.h>

int check_sgio(const char *device){
  int fd;
  struct sg_io_hdr hdr;

  if (!device) return 0;

  /* we don't really care what type of device it is -- if it can do
   * SG_IO, then we'll put it through the normal mmc/atapi/etc tests
   * later, but it's good enough for now. */
  fd = open(device, O_RDWR|O_NONBLOCK);
  if (fd < 0){
    printf("Could not access device %s to test for SG_IO support\n",device);
    return 0;
  }

  memset(&hdr, 0, sizeof (struct sg_io_hdr));
  /* First try with interface_id = 'A'; for all but the sg case,
   * that'll get us a -EINVAL if it supports SG_IO, and some other
   * error for all other cases. */
  hdr.interface_id = 'A';
  if (ioctl(fd, SG_IO, &hdr)) {
    int err=errno;
    printf("errno: %d\n", err);
    switch (err) {
    case EINVAL: /* sr and ata give us EINVAL when SG_IO is
                  * supported but interface_id is bad. */

    case ENOSYS: /* sg gives us ENOSYS when SG_IO is supported but
                  * interface_id is bad.  IMHO, this is wrong and
                  * needs fixing in the kernel. */

      close(fd);
      return 1;

    default: /* everything else gives ENOTTY, I think.  I'm just
              * going to be paranoid and reject everything else. */

      close(fd);
      return 0;

    }
  }
  /* if we get here, something is dreadfuly wrong. ioctl(fd,SG_IO,&hdr)
   * handled SG_IO, but took hdr.interface_id = 'A' as valid, and an empty
   * command as good.  Don't trust it. */
  printf("closing\n");
  close(fd);
  return 0;
}

int main(int argc, char**argv)
{
  const char *specialized_device = "/dev/sr0";

  if(check_sgio(specialized_device)){
     printf("SG_IO device: %s\n",specialized_device);
  }else{
     printf("no SG_IO support for device: %s\n",specialized_device);
  }
  return 0;
};

--------------9444AF95A2D512A04BF03B9C--
