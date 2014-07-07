From: Andy Grover <agrover@redhat.com>
Subject: Re: [RFC 0/2] target: userspace pass-through backend
Date: Mon, 07 Jul 2014 14:26:48 -0700
Message-ID: <53BB1098.3070501@redhat.com>
References: <1404241875-29164-1-git-send-email-agrover@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1404241875-29164-1-git-send-email-agrover@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, hch@lst.de, nab@linux-iscsi.org, shli@kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi, here's some additional beginning bits for the configuration and use 
of this code:

Changes to targetcli-fb and rtslib-fb:

https://github.com/agrover/targetcli-fb/tree/userback
https://github.com/agrover/rtslib-fb/tree/userback

An incredibly-crappy stand-in for the user process that will handle 
requests:

https://github.com/agrover/test-userback

I look forward to your feedback :)

Thanks -- Regards -- Andy

p.s. kernel changes are also available here:
https://github.com/agrover/linux/tree/userback
