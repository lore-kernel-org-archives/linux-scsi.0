From: "Subodh S" <subodh_s_1975@mail.com>
Subject: Servicing of requests
Date: Sun, 23 Mar 2003 07:18:50 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030323121850.48607.qmail@mail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org

Hi,

Whenever I read data of 'x'k size using one read() system call, I find batches of some 'y' no. of make_requests calls followed by the same no. of end_io's. Something like :
make_req
make_req
make_req
end_io
end_io
end_io
make_req
make_req
make_req
end_io
end_io
end_io

The output above gives me an idea that 3(hypothetical no.) buffer_heads above form a request.
(since 1 make_request corresponds to 1 buffer_head) and maybe since 1 request is serviced at a time I can see 3 make_req's together. Is my understanding right ??

But, I have read that sd uses some optimization algorithm to club requests so that the disk seek time is reduced. In which case since all requests are to adjecents sectors it should create a single request of all 'x'k assuming 1 buffer_head is of size 1k.

Does this make sense ??

-subodh
-- 
__________________________________________________________
Sign-up for your own FREE Personalized E-mail at Mail.com
http://www.mail.com/?sr=signup

