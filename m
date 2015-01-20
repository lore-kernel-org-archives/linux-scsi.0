From: Andy Grover <agrover@redhat.com>
Subject: tcmu-runner (target userspace passthrough daemon) development
Date: Tue, 20 Jan 2015 15:27:53 -0800
Message-ID: <54BEE479.4050503@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi all,

tcmu-runner is a userspace daemon that simplifies the configuration and 
processing of SCSI commands from LIO to userspace handlers, via the new 
TCMU userspace passthrough backstore.

https://github.com/agrover/tcmu-runner

As a proof-of-concept, I've implemented a Gluster backend handler. I'm 
looking for code review and collaborators, as well as suggestions on 
what other userspace handlers we might want to work on. Tape or optical 
jukebox emulation? VMDK files?? Video RAM???

Thanks -- Regards -- Andy

(BTW, tcmu-runner is not kernel code but it's very tightly linked to 
LIO, so recommend we use this list (target-devel) for discussion.)
