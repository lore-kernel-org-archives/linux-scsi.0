From: Andrew Morton <akpm@osdl.org>
Subject: recent sym2 breakage
Date: Mon, 16 Aug 2004 00:01:46 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040816000146.3f484151.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:39396 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S267475AbUHPHDY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Aug 2004 03:03:24 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linuxppc64-dev@lists.linuxppc.org


So I'm putting together 2.6.8.1-mm1, which is bigger than Ben Hur and it
seems that someone broke the sym2 driver, on ppc64 at least.

It runs OK, but a `halt -p' spits nasty messages, then hangs.

Can someone suggest what changes caused this?



Shutting down network interfaces:
    eth0                                                              done
Shutting down sound driver                                            done
Shutting down service at daemon                                       done
sym0:8:0: ABORT operation started.
sym0:8:0: ABORT operation timed-out.
sym0:8:0: ABORT operation started.  
sym0:8:0: ABORT operation timed-out.
sym0:8:0: ABORT operation started.  
sym0:8:0: ABORT operation timed-out.
sym0:8:0: ABORT operation started.  
sym0:8:0: ABORT operation timed-out.
sym0:8:0: ABORT operation started.  
sym0:8:0: ABORT operation timed-out.
sym0:8:0: ABORT operation started.  
sym0:8:0: ABORT operation timed-out.
sym0:8:0: ABORT operation started.  
sym0:8:0: ABORT operation timed-out.
sym0:8:0: ABORT operation started.  
sym0:8:0: ABORT operation timed-out.
sym0:8:0: ABORT operation started.  
sym0:8:0: ABORT operation timed-out.
sym0:8:0: ABORT operation started.  
sym0:8:0: ABORT operation timed-out.
sym0:8:0: ABORT operation started.  
sym0:8:0: ABORT operation timed-out.
sym0:8:0: ABORT operation started.  
sym0:8:0: ABORT operation timed-out.
sym0:8:0: ABORT operation started.  
sym0:8:0: ABORT operation timed-out.
sym0:8:0: ABORT operation started.  
sym0:8:0: ABORT operation timed-out.
sym0:8:0: ABORT operation started.  
sym0:8:0: ABORT operation timed-out.
sym0:8:0: ABORT operation started.  
sym0:8:0: ABORT operation timed-out.
sym0:8:0: DEVICE RESET operation started.
sym0:8:0: DEVICE RESET operation timed-out.
sym0:8:0: BUS RESET operation started.     
sym0:8:0: BUS RESET operation timed-out.
sym0:8:0: HOST RESET operation started. 
sym0: SCSI BUS has been reset.         
                              
