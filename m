From: Ric Wheeler <rwheeler@redhat.com>
Subject: [LSF/MM TOPIC] update on discard support & testing with vendors
Date: Mon, 17 Jan 2011 09:46:15 -0500
Message-ID: <4D345637.6000207@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: lsf-pc@lists.linuxfoundation.org, linux-fsdevel@vger.kernel.org, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


I would like to spend some time reviewing where we stand with the discard 
support - specifically review where we do in the stack (creation time, 
fine-grained during deletions, other bulk times), how the options perform and 
any performance results we have with various classes of devices (SCSI and SSD).

Similar interest in how the topology/alignment support has worked out.

Both topics took a lot of effort on our part and I expect that we are just now 
going to be hitting the point where hardware vendors take us seriously enough & 
are starting to test....

Ric

